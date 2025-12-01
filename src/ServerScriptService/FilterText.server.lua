--[[
	StoryMaker
	Author: @polarpanda16
	
	This module provides story maker game functionality for input handling 
	and other utility functions (e.g. reset)
	
	This script provides an abstraction so the that main script running the game
	`GameManager` is free from functions unrelated to gameplay. This
	includes functions such as resetting the game GUI, prompting the user
	to play again, and handling user input in the GUI elements.
]]--

-- ========================================
-- GLOBAL VARIABLES
-- ========================================
-- Variables that will be used globally (throughout) the script

local TextService = game:GetService("TextService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FilterEvent = Instance.new("RemoteFunction")
FilterEvent.Name = "FilterEvent"
FilterEvent.Parent = ReplicatedStorage
-- ========================================
-- ========================================





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
function filterText(player, message)
	local filteredTextResult = ""
	
	local success, errorMessage = pcall(function()
  		filteredTextResult = TextService:FilterStringAsync(message, player.UserId)
	end)

	if not success then
  		return ""
	end

	-- Assume message will be broadcasted (shared). Better to be safe than sorry.
	return filteredTextResult:GetNonChatStringForBroadcastAsync()
end

FilterEvent.OnServerInvoke = filterText
-- ========================================
-- ========================================