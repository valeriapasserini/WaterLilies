-- Definizione modulo
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y, width, height )

	if not parent then error( "ERROR: Expected display object" ) end

	--Inizializza i suoni e la scena
	local scene = composer.getScene( composer.getSceneName( "current" ) )


	--Carica lo spritesheet
	local sheetData = { width = 100, height = 100, numFrames = 6, sheetContentWidth = 300, sheetContentHeight = 200 }
    local sheet = graphics.newImageSheet( "waterlilie.png", sheetData )
    local sequenceData = {
        { name = "type1", frames = { 1 }  },
        { name = "type2", frames = { 2 }  },
        { name = "type3", frames = { 3 }  },
        { name = "type4", frames = { 4 }  },
        { name = "type5", frames = { 5 }  },
        { name = "type6", frames = { 6 }  },
    }
	waterlilie = display.newSprite( parent, sheet, sequenceData )
    waterlilie.x = x
    waterlilie.y = y
    waterlilie.width = width
    waterlilie.height = height
    waterlilie:setSequence(sequenceData[math.random(#sequenceData)].name)

	waterlilie:play()

	--Restituisce l'istanza "waterlilie"
	waterlilie.name = "waterlilie"
	waterlilie.type = "waterlilie"
	return waterlilie
end

return M