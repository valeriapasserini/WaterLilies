-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

-- include Corona's "physics" library
local physics = require "physics"
--------------------------------------------
local world=display.newGroup()
local frog= require('frog')
local waterlilie= require('waterlilie')
local waterlilies=display.newGroup()
local backworld= display.newGroup()
local fishes = display.newGroup()
local fish=require('fish')
local timebar = widget.newProgressView(
    {
        left = display.contentCenterX-50,
        top = 0,
        width = 100,
        isAnimated = true
    }
)
-- Set the progress to 50%
local countdown=1
local decrement=0.02
timebar:setProgress( countdown )

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- Code here runs when the scene is first created but has not yet appeared on screen
-- Load the previous scores


local function newFish(event)
	fish.new(fishes, (math.random(1,2)-1)*screenW, math.random(frog.y-display.actualContentHeight/2,frog.y), display.actualContentWidth/4,display.actualContentWidth/4)
	timerNewFish=timer.performWithDelay( math.random(1,4)*500, newFish )
end
local function enterFrame(event)
	for i = 1, waterlilies.numChildren do

		if waterlilies[i].y > frog.y+170 then
			waterlilies[i]:translate(0, -display.actualContentHeight)
			local pos={1,2,3,4}
			waterlilies[i].x= math.random(#pos)*(display.actualContentWidth/4)-(display.actualContentWidth/8)
			waterlilies[i].alpha = 0
			transition.fadeIn( waterlilies[i], { time=500 } )
		end
	end
	for i=1, fishes.numChildren do
		if not fishes[i]==nil then
			if fishes[i].y> frog.y+display.actualContentHeight then
        			display.remove( fishes[i] )
					fishes:remove(fishes[i])
					fishes[i]=nil
		 	end
	 	end
 	end
	local hx, hy = frog:localToContent(0,0)
	hx, hy = display.contentCenterX - hx, display.contentCenterY+150 - hy
	world.y = world.y + hy
end

local function onCollision()
    world:remove(frog)
    timer.cancel( timerNewFish )
    Runtime:removeEventListener("enterFrame", enterFrame)
    local stop =function() physics.stop() end
    timer.performWithDelay( 500,  stop )

end

local function eatTheFrog()
	local  eatFish= function()
		fish_=fish.new(fishes, (math.random(1,2)-1)*screenW, math.random(frog.y-display.actualContentHeight/2,frog.y), display.actualContentWidth/4,display.actualContentWidth/4)
		if math.random()>0.5 then fish_:setSequence('attackToLeft') fish_:play() fish_:translate(math.random(display.actualContentWidth+100,display.actualContentWidth+200), math.random(-display.actualContentHeight*2,-display.actualContentHeight/2)) ypos=frog.y+300 xpos=(((ypos-frog.y)/(fish_.y-frog.y))*(fish_.x-frog.x))+frog.x transition.moveTo( fish_, { x=xpos, y=ypos, time=2000 } ) fish_.rotation=math.deg(math.atan2((fish_.y-frog.y),(fish_.x-frog.x)))
		else fish_:setSequence('attackToRight') fish_:play() fish_:translate(math.random(-200,-100), math.random(-display.actualContentHeight*2,-display.actualContentHeight/2)) ypos=frog.y+300 xpos=(((ypos-frog.y)/(fish_.y-frog.y))*(fish_.x-frog.x))+frog.x transition.moveTo( fish_, { x=xpos, y=ypos, time=2000 } ) fish_.rotation=math.deg(math.atan2((fish_.y-frog.y),(fish_.x-frog.x))+math.pi) end
		fish_.alpha = 0
		transition.fadeIn( fish_, { time=500 } )
		physics.start()
		physics.setGravity( 0, 0 )
		physics.addBody(frog)
		physics.addBody(fish_)
		fish_.collision = onCollision
		fish_:addEventListener("collision")
    end
    timebar.alpha= 0
	timer.performWithDelay( 125, eatFish )

end
local function startCountdown()
    if actualScore%5==0 and actualScore>0 then
        decrement=decrement*1.2
    end
    if decrement>0.4 then
        decrement=0.4
    end
    countdown=countdown-decrement
    timebar:setProgress( countdown )
    local nearestwaterlilie=waterlilies[1]
    for i=1, waterlilies.numChildren do
        if waterlilies[i].y==frog.y and waterlilies[i].x==frog.x then nearestwaterlilie=waterlilies[i] end
    end
    if countdown<=0 then
        nearestwaterlilie.alpha=0
        timer.cancel(countdownTimer)
        eatTheFrog()
        frog:setSequence("jumpStraight")
        frog:play()
    elseif countdown<=0.5 and countdown>0 then
        nearestwaterlilie.alpha=nearestwaterlilie.alpha-0.1
    else
    end
    if countdown>=0 then
        countdownTimer=timer.performWithDelay( 500, startCountdown )
    end
end

local function onSceneTouch( event )

    if ( event.phase == "began" and countdown>0) then
		local unit = display.actualContentWidth/4
		local posx,posy=event.x,event.y
		rotazioneRad=-math.atan2((event.y-display.contentCenterY+150),(event.x-frog.x))
        rotazione= math.deg(rotazioneRad+math.pi/2)
		if event.x>frog.x-unit/2 and event.x>frog.x+unit/2 then frog:setSequence("jumpToRight") frog:play()
		elseif event.x<frog.x-unit/2 and event.x<frog.x+unit/2 then frog:setSequence("jumpToLeft") frog:play()
		else frog:setSequence("jumpStraight") frog:play()
		end
		local nearestwaterlilie=waterlilies[1]
		for i=1, waterlilies.numChildren do
			if waterlilies[i].y+unit*2>frog.y and  waterlilies[i].y<frog.y then nearestwaterlilie=waterlilies[i] end
		end
		local stop = function() frog:setSequence('default') frog:play() frog.rotation = 0 end

		if posy>display.actualContentHeight/8 then
			if posx<=nearestwaterlilie.x+unit/2 and posx>=nearestwaterlilie.x-unit/2 then transition.moveTo( frog, { x=nearestwaterlilie.x, y=nearestwaterlilie.y, time=125 } ) frog.rotation = rotazione timer.performWithDelay( 160, stop ) actualScore=actualScore+1 score.text=actualScore countdown=1 timer.cancel(countdownTimer) startCountdown()
			elseif posx>0 and posx<=unit then transition.moveTo( frog, { x=(display.screenOriginX+unit)/2, y=frog.y-display.actualContentWidth/4, time=125 } ) frog.rotation = rotazione timer.cancel(countdownTimer) backworld:removeEventListener( "touch", onSceneTouch ) eatTheFrog()
			elseif posx>unit and posx<=unit*2 then transition.moveTo( frog, { x=(unit+unit*2)/2, y=frog.y-display.actualContentWidth/4, time=125 } ) frog.rotation = rotazione timer.cancel(countdownTimer) backworld:removeEventListener( "touch", onSceneTouch ) eatTheFrog()
			elseif posx>unit*2 and posx<=unit*3 then transition.moveTo( frog, { x=(unit*2+unit*3)/2, y=frog.y-display.actualContentWidth/4, time=125 } ) frog.rotation = rotazione timer.cancel(countdownTimer) backworld:removeEventListener( "touch", onSceneTouch ) eatTheFrog()
			elseif posx>unit*3 and posx<=unit*4 then transition.moveTo( frog, { x=(unit*3+unit*4)/2, y=frog.y-display.actualContentWidth/4, time=125} ) frog.rotation = rotazione timer.cancel(countdownTimer) backworld:removeEventListener( "touch", onSceneTouch ) eatTheFrog()
			end
        else frog:setSequence('default') frog:play() frog.rotation = 0 end

	end
	return true
end



function scene:create( event )
	local sceneGroup = self.view


	local background = display.newImageRect( "background.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY
	local sea = display.newImageRect( "sea.jpg", display.actualContentWidth, display.actualContentHeight )
	sea.anchorX = 0
	sea.anchorY = 0
	sea.x = 0 + display.screenOriginX
	sea.y = 0 + display.screenOriginY
	sea.alpha=0.4
	-- make a waterlilie (off-screen), position it, and rotate slightly
	math.randomseed(os.time())
	backworld:insert(background)
	backworld:insert(sea)

	for i=1, math.floor((display.actualContentHeight*4)/display.actualContentWidth)
	do
		local pos={1,2,3,4}
		local x= math.random(#pos)*(display.actualContentWidth/4)-(display.actualContentWidth/8)
		local y= i*(display.actualContentWidth/4)-(display.actualContentWidth/4)-150
		local r=math.random(360)
		waterlilie_ = waterlilie.new(waterlilies, x,  y, display.actualContentWidth/4, display.actualContentWidth/4 )
		waterlilie_.rotation = r
    end
    local nearestwaterlilie=waterlilies[waterlilies.numChildren]
    frog=frog.new(world, nearestwaterlilie.x,  nearestwaterlilie.y, display.actualContentWidth/4, display.actualContentWidth/4 )


	world:insert(fishes)
	world:insert(waterlilies)
    world:insert(frog)
	sceneGroup:insert(backworld)
	sceneGroup:insert(world)


	-- add physics to the waterlilie
	-- physics.addBody( waterlilie, { density=1.0, friction=0.3, bounce=0.3 } )

	-- create a grass object and add physics (with custom shape)

	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	--local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	--physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )

	-- all display objects must be inserted into group

end
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		-- We need physics started to add bodies, but we don't want the simulaton
		-- running until the scene is on the screen.
		-- physics.start()
		-- physics.pause()

		-- create a grey rectangle as the backdrop
		-- the physical screen will likely be a different shape than our defined content area
		-- since we are going to position the background from it's top, left corner, draw the
		-- background at the real top, left corner.

	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.
		timerNewFish=timer.performWithDelay( math.random(1,2)*1500, newFish )
		backworld:addEventListener( "touch", onSceneTouch )
        Runtime:addEventListener("enterFrame", enterFrame)


	end
end

function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
        --
        timer.cancel(timerNewFish)
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen

	end

end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
    --

	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene