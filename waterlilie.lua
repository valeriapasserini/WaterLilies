-- Definizione modulo
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y, width, height )

	if not parent then error( "ERROR: Expected display object" ) end

	--Inizializza i suoni e la scena
	local scene = composer.getScene( composer.getSceneName( "current" ) )


	--Carica lo spritesheet
	local sheetData = {  }
    local sheet = graphics.newImageSheet( "waterlilie.png", sheetData )
    local sequenceData = {

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