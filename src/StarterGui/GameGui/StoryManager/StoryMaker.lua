--[[
	StoryMaker
	Author: @polarpanda16
	
	This module provides story maker game functionality for input handling 
	and other utility functions (e.g. reset)
	
	This script provides an abstraction so the that main script running the game
	`StoryManager` is free from functions unrelated to gameplay. This
	includes functions such as resetting the game GUI, prompting the user
	to play again, and handling user input in the GUI elements.
]]--

-- ========================================
-- GLOBAL VARIABLES
-- ========================================
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

local Players = game:GetService("Players")

-- Local player
local player = Players.LocalPlayer

-- Container for externally accessible (public) functions
local StoryMaker = {}

-- BoolValue used to determine whether the player is already interacting
local Interacting = script.Parent:WaitForChild("Interacting")

-- Event used to filter text server-side
--local FilterEvent = script.Parent:WaitForChild("FilterText"):WaitForChild("FilterEvent")
local FilterEvent = nil

-- Used by GetInput() to track when user input is handled
local gotInput = false

-- Max size used by ScaleFrame
local MAX_SIZE = math.huge

-- String used as a placeholder for user input (replaced when user provides input)
local WORD_BLANK = "_____"

local StoryManager = script.Parent
-- ScreenGui containing the game
local GameGui = StoryManager.Parent
-- Frame that contains the game
local GameFrame = GameGui:WaitForChild("GameFrame")
local InputFrame = GameFrame:WaitForChild("InputFrame")
local IntroFrame = GameFrame:WaitForChild("IntroFrame")
local InputTextbox = InputFrame:WaitForChild("InputTextbox"):WaitForChild("Textbox")
local SubmitInputButton = InputFrame:WaitForChild("SubmitInputButton")
local IntroText = IntroFrame:WaitForChild("IntroText")
-- ScrollingFrame containing the StoryText TextBox
local StoryTextContainer = GameFrame:WaitForChild("StoryTextContainer")
local StoryScrollingFrame = StoryTextContainer:WaitForChild("StoryScrollingFrame")
-- The TextBox containing the story
local StoryText = StoryScrollingFrame:WaitForChild("StoryText")
-- Frame and button used to display/hide AddCode prompt
local AddCodePrompt = GameGui:FindFirstChild("AddCodePrompt")
local CloseAddCodePromptButton = AddCodePrompt:FindFirstChild("ClosePromptButton")
-- ========================================
-- ========================================





-- ========================================
-- UTILITY FUNCTIONS
-- ========================================
-- Functions unrelated to gameplay but necessary for game performance
-- (e.g. resetting game GUI)

-- * Handles keyboard input and sets 'gotInput' to true if the user
--	 pressed the Return key
--
--	 Arguments: 
--		input - 
--		gameProcessed - Whether the event was process by Roblox
--	 Return: None
-- *
local function handleKeyboardReturn(input, gameProcessedEvent)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local keyPressed = input.KeyCode
		if keyPressed ~= Enum.KeyCode.Return then return end
	end
	
	gotInput = true
end

-- * Handles mouse click input by setting 'gotInput' to true
--
--	 Arguments: None
--	 Return: None
-- *
local function handleButtonActivated()
	gotInput = true
	wait()
	InputTextbox:CaptureFocus()
end

-- * Opens the `AddCodePrompt` prompt
--
--	 Arguments: None
--	 Return: None
-- * 
local function openAddCodePrompt()
	local targetSize = UDim2.new(0.35, 0, 0.3, 0)
	AddCodePrompt.Visible = true
	AddCodePrompt:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
end

-- * Waits for, and returns, user input
--
--	 Arguments: None
--	 Return: None
-- *
local function getResponse()
	gotInput = false
	
	-- Wait for user to enter a word. Do not continue until a valid word is
	-- entered
	local SubmitButtonConnection = SubmitInputButton.Activated:Connect(handleButtonActivated)
	local KeyBoardReturn = UserInputService.InputBegan:Connect(handleKeyboardReturn)
		
	repeat wait() until gotInput 
	gotInput = false
		
	SubmitButtonConnection:Disconnect()
	KeyBoardReturn:Disconnect()
	
	return string.lower(InputTextbox.Text)
end

-- * Resets the game by clearing all text fields and setting the
--	 `InputTextBox`'s placeholder text to default message
--
--	 Arguments: None
--	 Return: None
-- *
function StoryMaker:Reset()
	IntroText.Text = "Hi "..player.Name..",\n\n".."Answer the questions to write your very own story."
	
	StoryText.Text = ""
	scaleFrame()
	
	InputTextbox.Text = ""
	InputTextbox.PlaceholderText = "Type Answer Here"
end

-- * Appends the message argument to the end of the StoryText text
--	 character by character
--
--	 Arguments: "message" The string being appended
--	 Return: None
-- *
function StoryMaker:Write(message)
	-- Clear story textbox
	StoryText.Text = ""
	
	if not message then
		openAddCodePrompt()
		return
	end
	
	-- Write story character by character
	for i=1, string.len(message) do
		StoryText.Text = StoryText.Text..string.sub(message,i,i)
		scaleFrame()
		wait(.01)
	end
end
-- ========================================
-- ========================================


function StoryMaker:Escribir(message)
	-- Clear story textbox
	
	if not message then
		openAddCodePrompt()
		return
	end
	
	-- Write story character by character
	for i=1, string.len(message) do
		StoryText.Text = StoryText.Text..string.sub(message,i,i)
		scaleFrame()
		wait(.01)
	end
end

-- ========================================
-- TEXT FILTER FUNCTIONS (LOCAL TO MODULE)
-- ========================================
-- Function/event handler(s) for text filtering
-- Runs on the server to access the TextService Roblox service.

-- * Filters the sender's message and returns the filter result or "" if unsuccessful
--
--	 Arguments: "message" - Message to be filtered
--	 Return: Filtered message or "" if filter failed
-- *
local function filterText(message)
	if not FilterEvent then
		FilterEvent = ReplicatedStorage:WaitForChild("FilterEvent")
	end

	return FilterEvent:InvokeServer(message)
end
-- ========================================
-- ========================================





-- ========================================
-- INPUT HANDLER FUNCTIONS
-- ========================================
-- Function/event handlers for user input

-- * Prompt user to play again or exit. Do not continue until player
--	 enters either 'Yes' or 'No'.
--
--	 Arguments: None
--	 Return: None
-- * 
function StoryMaker:PlayAgain()
	InputTextbox.PlaceholderText = "Play again? Yes/No"
	
	while true do
		local response = getResponse()
		
		if (response == "yes") then
			return true
		elseif (response == "no") then
			Interacting.Value = false
			return false
		else
			InputTextbox.Text = ""
		end
	end
end

-- * Prompts the user to input a word depending on the type of blank (e.g.
--	 noun, verb, etc.). Waits until a valid word is enterred before returning
--	 the user's input string.
--
--	 Arguments:
--		word: The type of word asking the player to input
--	 Return: The user's input string.
-- *
function StoryMaker:GetInput(question)
	local filteredWord = filterText(question)
	
	if StoryText.Text ~= "" then 
		StoryText.Text = StoryText.Text..'\n'
	end
	
	-- Display input prompt messages
	if question == filteredWord then
		StoryText.Text = question
	else
		StoryText.Text = StoryText.Text.."Enter a word below and press Submit!"
	end
	
	local success = false
	local response = nil
	local filteredResponse = nil
	while not success do
		-- Wait for user to enter a word. Do not continue until a valid word is
		-- entered
		response = getResponse()
		filteredResponse = filterText(response)
		
		InputTextbox.Text = filteredResponse
		if (string.gsub(filteredResponse, " ", "") ~= "") then success = true end
	end
	
	-- Reset input box message
	InputTextbox.Text = ""
	
	scaleFrame()
	
	InputTextbox:CaptureFocus()
	
	-- Return user input
	return filteredResponse
end
-- ========================================
-- ========================================





-- ========================================
-- SCROLLINGFRAME SCALING FUNCTION
-- ========================================
-- Scales the ScrollingFrame containing the story textbox to fit the
-- text perfectly

function scaleFrame()
	local max_x = StoryScrollingFrame.AbsoluteSize.X
	
	local text = StoryText.Text
	local FontSize = string.gsub(tostring(StoryText.TextSize), "Enum.FontSize.Size", "")
	
	local v = TextService:GetTextSize(StoryText.Text, FontSize, StoryText.Font, Vector2.new(max_x, MAX_SIZE))
		
	StoryScrollingFrame.CanvasSize = UDim2.new(0, v.x, 0, v.y)
end
-- ========================================
-- ========================================

return StoryMaker