--[[
	InteractionManager
	Author: @polarpanda16
	
	This script runs locally for the player.
	
	This script checks processes local player input on a TextButton and via
	the UserInputService event InputBegan. 
	
	When a player interacts with the TextButton or presses KEY the game GUI 
	is opened unless the player is already interacting.
]]--


-- ========================================
-- GLOBAL VARIABLES
-- ========================================
local ContextActionService = game:GetService("ContextActionService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

-- Key that user can press to interact with game
local KEY = Enum.KeyCode.E

-- Object that the player can interact with
-- Objects that the player can interact with
local TARGET_TAG = "Interactible"
local targets = CollectionService:GetTagged(TARGET_TAG)
local clickDetectors = {}

-- Maximum distance away that the player can interact with target
local MAX_DISTANCE = 15

-- Script responsible for running the Story Maker game
local StoryManager = script.Parent

-- BoolValue used to determine whether the player is already interacting
local Interacting = StoryManager:WaitForChild("Interacting")

-- Local player
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ScreenGui containing the game
local GameGui = StoryManager.Parent
-- Frame that contains the game
local GameFrame = GameGui:WaitForChild("GameFrame")
-- Frame and TextBox used to accept user input
local InputFrame = GameFrame:WaitForChild("InputFrame")
local InputTextbox = InputFrame:WaitForChild("InputTextbox"):WaitForChild("Textbox")
local SubmitInputButton = InputFrame:WaitForChild("SubmitInputButton")
-- Frame and button used to display/hide AddCode prompt
local AddCodePrompt = GameGui:FindFirstChild("AddCodePrompt")
local CloseAddCodePromptButton = AddCodePrompt:FindFirstChild("ClosePromptButton")
-- Button used to exit game
local ExitButton = GameFrame:WaitForChild("ExitButton")
-- ========================================
-- ========================================





-- ========================================
-- USERINPUT/INTERACTION FUNCTIONS
-- ========================================
-- Functions that handle user input with the GUIs prompting the player to
-- interact with the game

-- * Fires when `Interacting` BoolValue changes value. If it changes to true,
--   opens the game window and starts the game. If it changes to false,
--	 closes game window and ends game.
--
--	 Arguments: None
--	 Return: None
-- * 
local function changed(value)
	if value == true then
		GameFrame.Visible = true
		StoryManager.Disabled = false
		
		for _,clickDetector in pairs (clickDetectors) do
			clickDetector.MaxActivationRange = 0
		end
		
		wait()
		InputTextbox:CaptureFocus()
	else
		GameFrame.Visible = false
		StoryManager.Disabled = true

		for _,clickDetector in pairs (clickDetectors) do
			clickDetector.MaxActivationRange = MAX_DISTANCE
		end
		
		wait()
		InputTextbox:ReleaseFocus()
	end
end
Interacting.Changed:Connect(changed)

-- * Fires when the local player begins input. Ignores all input except if
--	 the user presses `KEY`. If `KEY` is pressed opens the game GUI unless
--	 player already interacting with the game
--
--	 Arguments: 
--		actionName - Name of the ContextActionService action
--		userInputState - State of input
--		inputObject - Contains info about input
--	 Return: None
-- *
local function openKeyboard(actionName, userInputState, inputObject)
	if not (userInputState == Enum.UserInputState.Begin) then return end
	
	for _, target in pairs (targets) do
		local InteractionFrame = target:WaitForChild("InteractionFrame")
		if ((InteractionFrame.Enabled == true) or (Interacting.Value == true and not InputTextbox:IsFocused())) then
			Interacting.Value = not Interacting.Value
			return
		end
	end
end
local function openMouse(playerWhoClicked)
	if playerWhoClicked then
		for _, target in pairs (targets) do
			local InteractionFrame = target:WaitForChild("InteractionFrame")
			if ((InteractionFrame.Enabled == true) or (Interacting.Value == true and not InputTextbox:IsFocused())) then
				Interacting.Value = not Interacting.Value
				return
			end
		end
	end
end
ContextActionService:BindAction("OpenBook", openKeyboard, false, KEY)

-- * Re-captures Textbox focus if `InputTextbox` lost focus because
--	 the user pressed enter/return
--
--	 Arguments: 
--		enterPressed - Whether the client pressed Enter to lose focus
--		inputThatCausedFocusLoss - An `InputObject` instance indicating 
--									the type of input that caused the 
--									TextBox to lose focus
--	 Return: None
-- * 
local function focusLost(enterPressed, inputThatCausedFocusLoss)
	if enterPressed and Interacting.Value then
		wait()
		InputTextbox:CaptureFocus()
	end	
end
InputTextbox.FocusLost:Connect(focusLost)

-- * Fires when the local player activates/interacts with the
--	 `ExitButton` GUI. Sets `Interacting` BoolValue to false.
--
--	 Arguments: None
--	 Return: None
-- * 
local function exit()
	Interacting.Value = false
end
ExitButton.Activated:Connect(exit)

-- * Fires when the local player's acticates/interacts with the
--	 `ExitButton` GUI. Closes the prompt UI
--
--	 Arguments: None
--	 Return: None
-- * 
local function closeAddCodePrompt()
	local targetSize = UDim2.new(0, 0, 0, 0)
	AddCodePrompt:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
	wait(0.25)
	AddCodePrompt.Visible = false
end
CloseAddCodePromptButton.Activated:Connect(closeAddCodePrompt)
-- ========================================
-- ========================================





-- ========================================
-- TARGET AND CLICKDETECTOR DETECTION
-- ========================================
--

-- * Fires when a new target is added to determine if the target has a
--	 `ClickDetector` child. If so, set up the ClickDetector by setting
--	 its MaxActivationDistance and connecting it to the `openMouse()`
--	 function on MouseClick
--
--	 Arguments:
--		target: The added target instance
-- *
local function getClickDetector(target)
	local clickDetector = target:FindFirstChildWhichIsA("ClickDetector")
	if clickDetector then
		-- Set ClickDetector MaxDistance
		clickDetector.MaxActivationDistance = MAX_DISTANCE
		-- Connect ClickDetector to open event
		clickDetector.MouseClick:Connect(openMouse)
	end
end

-- *
-- *
local function addTarget(target)
	getClickDetector(target)
end

CollectionService:GetInstanceAddedSignal(TARGET_TAG):Connect(addTarget)

-- *
-- *
for _, target in pairs (targets) do
	getClickDetector(target)
end
-- ========================================
-- ========================================





-- ========================================
-- PROXIMITY DETECTOR FUNCTIONS
-- ========================================
-- Functions used to check if the player is within range of a target object. If in
-- range, an interaction prompt gui is displayed unless the player is already
-- interacting.
	
-- * Indicates whether the local player is in range of the `target` object
--
--   Arguments: None
--   Return: Boolean whether player is in range
-- *
function inRange()
	local minPos = HumanoidRootPart.Position - Vector3.new(MAX_DISTANCE/2, MAX_DISTANCE/2, MAX_DISTANCE/2)
	local maxPos = HumanoidRootPart.Position + Vector3.new(MAX_DISTANCE/2, MAX_DISTANCE/2, MAX_DISTANCE/2)
	local region = Region3.new(minPos, maxPos)
	
	return (#game.Workspace:FindPartsInRegion3WithWhiteList(region, targets) > 0)
end

-- * Indicates whether the local player is interacting with the game by 
--   checking the value of the `Interacting` BoolValue
--
--   Arguments: None
--   Return: Boolean whether player is interacting
-- *
function isInteracting()
	return script.Parent:WaitForChild("Interacting").Value
end

-- * Once per frame, checks if the local player is in range of the target
--	 object. If in range and not already interacting, show the interaction
local function onRenderStep()
	for _, target in pairs (targets) do
		local InteractionFrame = target:WaitForChild("InteractionFrame")
	
		if(inRange() and not isInteracting()) then
			InteractionFrame.Enabled = true
		else
			InteractionFrame.Enabled = false
		end
	end
end

RunService:BindToRenderStep("ProximityDetector", Enum.RenderPriority.First.Value, onRenderStep)
-- ========================================
-- ========================================