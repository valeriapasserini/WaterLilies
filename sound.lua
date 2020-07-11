
local M = {}
local composer = require( "composer" )

function M.new( parent, x, y )
	if not parent then error( "ERROR: Expected display object" ) end

	-- Get scene and sounds
	local scene = composer.getScene( composer.getSceneName( "current" ) )

	-- Load spritesheet
	local sheetData = { width = 24, height = 24, numFrames = 2, sheetContentWidth = 48, sheetContentHeight = 24 }
	local sheet = graphics.newImageSheet( "sound.png", sheetData )
	local sequenceData = {
		{ name = "soundOn", frames = { 1}  },
		{ name = "soundOff", frames = { 2}  },

	}
	sound = display.newSprite( parent, sheet, sequenceData )
	sound.x, sound.y, sound.width,sound.height  = x, y, 25, 25
	if composer.getVariable( "sound" ) then
		sound:setSequence("soundOn")
else
	sound:setSequence("soundOff")
end
	sound:play()
	sound.name = "sound"
	sound.type = "sound"
	return sound
end

return M