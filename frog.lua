-- Definizione modulo
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y, width, height )

	if not parent then error( "ERROR: Expected display object" ) end

	--Inizializza i suoni e la scena
	local scene = composer.getScene( composer.getSceneName( "current" ) )


	--Carica lo spritesheet
	local sheetData = { }
	local sheet = graphics.newImageSheet( "frog.png", sheetData )
	local sequenceData = {

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