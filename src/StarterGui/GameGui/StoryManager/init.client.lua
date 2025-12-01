-- GLOBAL VARIABLES
local storyMaker = require(script:WaitForChild("StoryMaker"))

--[[
En luau NO se usan rutas clasicas (con "../carpeta/archivo"), son especialitos
Lo que se hace es script (o sea este script).parent (su padre, no hace falta si script es el que engloba los hijos)
.loquesea
Con un :waitforchild si podria o no aparecer
]]

local passwords = require(script.Parent.Passwords.storymoduler)

-- Code controlling the game
local playing = true


while playing do
	storyMaker:Reset()
	
	-- Code story between the dashes	
	-- =============================================
	local pwd = storyMaker:GetInput("Put a password to see alternate stories"):lower():match("^%s*(.-)%s*$")

	-- En lua se puede usar de comparador el termino array[key] para comprobar si existe
	if passwords[pwd] then 
		-- Le pasamos a .script de passwords[pwd] el parametro storyMaker y lo ejecutamos
		passwords[pwd].script(storyMaker)
	else
	
	storyMaker:Write("Alo")
	end
	-- =============================================
		
	-- Add the story variable between the parenthesis below 
	-- Play again?
	playing = storyMaker:PlayAgain()
end


