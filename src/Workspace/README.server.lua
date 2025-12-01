
--[[README
	1. To complete game, add story and questions to StarterGUI > GameGUI > StoryManager
	2. Use storyMaker:GetInput() to ask players questions and store answers. Example: local name01 = storyMaker:GetInput("Who is your favortite musician?")
	3. To create the story, create a variable and concatenate the variable and sentence. Example: local story = "My name is " .. name01
	4. Pass the story variable into storyMaker:Write(). Example: storyMaker:Write(story) 
	___________________________________________________________________________
	Completed Example
	
	--Special achnowledgement @polarpanda16.

	-- GLOBAL VARIABLES
	local storyMaker = require(script:WaitForChild("StoryMaker"))

	-- Code controlling the game
	local playing = true

	while playing do
		storyMaker:Reset()
	
		-- Code story between the dashes	
		-- =============================================

	 	local name01 = storyMaker:GetInput("Question")
		local story = "My name is " .. name01
	
	
	
	
	
	
		-- =============================================
		
		-- Calls StoryMaker ModuleScript
		storyMaker:Write(story)
	
		-- Play again?
		playing = storyMaker:PlayAgain()
	end
	
--]] 