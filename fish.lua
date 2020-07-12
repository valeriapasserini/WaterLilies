-- Definizione modulo
local M = {}

local composer = require( "composer" )

function M.new( parent, x, y, width, height )

	if not parent then error( "ERROR: Expected display object" ) end

	--Inizializza i suoni e la scena
	local scene = composer.getScene( composer.getSceneName( "current" ) )


	--Carica lo spritesheet
	local sheetData = { width = 200, height = 100, numFrames = 4, sheetContentWidth = 400, sheetContentHeight = 200 }
	local sheet = graphics.newImageSheet( "fish.png", sheetData )
	local sequenceData = {
		{ name = "swimToLeft", frames = { 1, 2 } , time = 500, loopCount = 0, loopDirection = "bounce" },
		{ name = "swimToRight", frames = { 3, 4 } , time = 500, loopCount = 0, loopDirection = "bounce" },
		{ name = "attackToLeft", frames = { 1, 2 } , time = 125, loopCount = 0, loopDirection = "bounce" },
		{ name = "attackToRight", frames = { 3, 4 } , time = 125, loopCount = 0, loopDirection = "bounce" },

	}
	fish = display.newSprite( parent, sheet, sequenceData )
    fish.x= x
    fish.y= y
    fish.width=width
    fish.height = height

	if math.random()>0.5 then fish:setSequence('swimToLeft') fish:play() fish:translate(math.random(display.actualContentWidth+100,display.actualContentWidth+200), math.random(-display.actualContentHeight*2,-display.actualContentHeight/2)) transition.moveTo( fish, { x=-200, y=frog.y, time=2000 } ) fish.rotation=math.deg(math.atan2((fish.y-frog.y),(fish.x-0)))
	else fish:setSequence('swimToRight') fish:play() fish:translate(math.random(-200,-100), math.random(-display.actualContentHeight*2,-display.actualContentHeight/2)) transition.moveTo( fish, { x=display.actualContentWidth+200, y=frog.y, time=2000 } ) fish.rotation=math.deg(math.atan2((fish.y-frog.y),(fish.x-display.actualContentWidth))+math.pi) end
	fish.alpha = 0
	transition.fadeIn( fish, { time=500 } )

	fish:play()

	--Restituisce l'istanza "fish"
	fish.name = "fish"
	fish.type = "fish"
	return fish
end

return M