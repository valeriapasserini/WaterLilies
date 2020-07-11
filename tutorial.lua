-- Definizione modulo
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y, width, height )

	if not parent then error( "ERROR: Expected display object" ) end

	--Inizializza i suoni e la scena
	local scene = composer.getScene( composer.getSceneName( "current" ) )


	--Carica lo spritesheet
	local sheetData = { width = 640, height = 1136, numFrames = 133, sheetContentWidth = 3200, sheetContentHeight = 30672 }
    local sheet = graphics.newImageSheet( "tutorial.png", sheetData )
    local sequenceData = {
        {
            name = "tutorial",
            start = 1,
            count = 133,
            time = 20,
            loopCount = 4
        },
    }
	tutorial = display.newSprite( parent, sheet, sequenceData )
    tutorial.x = x
    tutorial.y = y
    tutorial.width = width
    tutorial.height = height
    tutorial:setSequence(sequenceData[math.random(#sequenceData)].name)

	tutorial:play()

	--Restituisce l'istanza "tutorial"
	tutorial.name = "tutorial"
	tutorial.type = "tutorial"
	return tutorial
end

return M