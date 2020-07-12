-- Definizione modulo
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y, width, height )

	if not parent then error( "ERROR: Expected display object" ) end

	--Inizializza i suoni e la scena
	local scene = composer.getScene( composer.getSceneName( "current" ) )


	--Carica lo spritesheet
	local sheetData = { width = 100, height = 100, numFrames = 4, sheetContentWidth = 200, sheetContentHeight = 200 }
	local sheet = graphics.newImageSheet( "frog.png", sheetData )
	local sequenceData = {
        { name = "default", frames = { 1 } , time = 300, loopCount = 0, loopDirection = "bounce" },
        { name = "jumpStraight", frames = { 1, 2, 1 } , time = 125, loopCount = 0, loopDirection = "bounce" },
		{ name = "jumpToRight", frames = { 1, 3, 2, 4, 1 } , time = 125, loopCount = 0, loopDirection = "bounce" },
		{ name = "jumpToLeft", frames = { 1, 4, 2, 3, 1 } , time = 125, loopCount = 0, loopDirection = "bounce" },
	}
	frog = display.newSprite( parent, sheet, sequenceData )
    frog.x= x
    frog.y= y
    frog.width=width
    frog.height = height

	frog:setSequence( "default" )

	frog:play()

	--Restituisce l'istanza "frog"
	frog.name = "frog"
	frog.type = "frog"
	return frog
end

return M