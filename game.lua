-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local pause, press=false, false
local backBtn
local pauseBtn
local restartBtn
local result
local timerPause
local splash = audio.loadSound( "splash.mp3" )
local click = audio.loadSound( "click.mp3" )
local crack = audio.loadSound( "crack.mp3" )

local json = require( "json" )

local actualScore=0
local actualRecord = composer.getVariable( "record" )
local tutorial={}
local filePath2 = system.pathForFile( "tutorial.json", system.DocumentsDirectory )

local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

if composer.getVariable( "sound" )==nil then
	composer.setVariable( "sound",true )
end

local score = display.newText( 0, display.contentCenterX, 40,  "Herculanum", 50 )
score:setFillColor( 1, 1, 1 )
local record = display.newText( "Record: "..actualRecord, display.contentCenterX, 70,  "Herculanum", 15 )
record:setFillColor( 1, 1, 1 )
record.alpha=0.6
local secondi=3
local time
local fog
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

local function loadScores()
	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
        	io.close( file )
        	scoresTable = json.decode( contents )
    	end

    	if ( scoresTable == nil or #scoresTable == 0 ) then
        	scoresTable = { 0, 0, 0}
    	end
end

composer.setVariable( "record", scoresTable[1] )

local function saveScores()
	for i = #scoresTable, 4, -1 do
        	table.remove( scoresTable, i )
    	end

    	local file = io.open( filePath, "w" )
	if file then
        	file:write( json.encode( scoresTable ) )
        	io.close( file )
    	end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- Code here runs when the scene is first created but has not yet appeared on screen
-- Load the previous scores

-- Sort the table entries from highest to lowest
local function compare( a, b )
	return a > b
end


local function loadTutorial()
	local file = io.open( filePath2, "r" )
	if file then
        	local contents = file:read( "*a" )
        	io.close( file )
        	tutorial = json.decode( contents )
    	end

    	if ( tutorial == nil or #tutorial == 0 ) then --or #tutorial == 0
        	tutorial = {true}
    	end
end

local function saveTutorial()
	table.remove( tutorial )
	local file = io.open( filePath2, "w" )
	if file then
        	file:write( json.encode( tutorial ) )
        	io.close( file )
    	end
end

local function bestScore()
	record.text="Record: "..actualScore
end

local function onBackBtnRelease()
	audio.play( click, {channel = 2} )
	-- go to game.lua scene
    audio.stop(1)
    display.remove(onPauseBtnRelease)
	display.remove(fog)
	display.remove( time )
 	display.remove(restartBtn)
     display.remove( result )
     display.remove( timebar )
    timer.cancel( timerNewFish )
    timer.cancel( countdownTimer )
	composer.removeScene( "game")
	composer.gotoScene( "menu", "fade", 400 )
	return true	-- indicates successful touch
end

local function onRestartBtnRelease()
	audio.play(click, {channel = 2})
	audio.stop(1)

  	display.remove(restartBtn)
	display.remove(fog)
 	display.remove( time )
    display.remove( timebar )
    display.remove( world )
    display.remove( backworld )
    display.remove( result )
	timer.cancel( countdownTimer )
	timer.cancel( timerNewFish )


	loadScores()

	-- Insert the saved score from the last game into the table, then reset it
	table.insert( scoresTable, composer.getVariable( "finalScore" ) )
	composer.setVariable( "finalScore", 0 )
	table.sort( scoresTable, compare )

	-- Save the scores
	saveScores()
	composer.setVariable( "record", scoresTable[1] )

	composer.removeScene( "game")
	composer.gotoScene( "game", "fade", 400 )
	return true	-- indicates successful touch
end
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
    fog=display.newImageRect( "sea.jpg", display.actualContentWidth, display.actualContentHeight )
    fog.anchorX = 0
    fog.anchorY = 0
    fog.x = 0 + display.screenOriginX
    fog.y = 0 + display.screenOriginY
    fog:setFillColor(0,0,0)
    fog.alpha=0.5
    restartBtn = widget.newButton{
        textOnly=true,
        font="Herculanum",
        label="Restart",
        labelColor = { over={ 0, 0, 0 }, default={ 1, 1, 1, 1 } },
        default="button.png",
        over="button-over.png",
        width=300, height=100,
        onRelease = onRestartBtnRelease	-- event listener function
    }

    restartBtn.x = display.contentCenterX
    restartBtn.y = display.contentCenterY*1.3
    display.remove(score)
    display.remove(record)
    time = display.newText( "Score: " .. actualScore, display.contentCenterX, display.contentCenterY, "Herculanum", 50 )
    time:setFillColor( 1, 1, 1 )
    composer.setVariable( "finalScore", actualScore )
        result = display.newText( "Record: " .. actualRecord, display.contentCenterX, display.contentCenterY*1.15, "Herculanum", 15 )
       result:setFillColor( 1, 1, 1 )

    if actualScore>actualRecord then
        result.text="New Record: "..actualScore.."!"
        composer.setVariable( "record", actualScore )
    end

    pauseBtn:toBack()
    loadScores()

    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )
    table.sort( scoresTable, compare )

    -- Save the scores
    saveScores()
    composer.setVariable( "record", scoresTable[1] )
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
    audio.play(splash, {channel = 1})

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
    audio.play( crack, {channel = 2} )
	-- go to game.lua scene
	audio.stop(2)
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
        if actualScore>=actualRecord then
            bestScore()
         end
	end
	return true
end

local function ready(event)
	pauseBtn:setLabel("Pause")
	score:setFillColor( 1, 1, 1 )
	display.remove( fog )
	timer.cancel(watch)
	timer.cancel(timerPause)
 	display.remove(time)
    timer.resume(timerNewFish)
    timer.resume(countdownTimer)
	backworld:addEventListener( "touch", onSceneTouch )
	press=false
	secondi=3
end

local function clock(event)
	 if secondi > 0 then
		secondi=secondi-1
		time.text= secondi
	else
		timer.cancel(timerPause)
	end
end

local function onPauseBtnRelease()
	audio.play(click, {channel = 2})
	if pause and not press then
		pauseBtn:setLabel("")
		time.text= secondi
		watch=timer.performWithDelay( 1000, clock , secondi )
		timerPause=timer.performWithDelay( 3000, ready, secondi )
		pause, press=false, true
	elseif not press then
        pauseBtn:setLabel("Start")
		time = display.newText( "Pause", display.contentCenterX, display.contentCenterY, "Herculanum", 100 )
	 	time:setFillColor( 1, 1, 1 )
	 	score:setFillColor( 0.7, 0.7, 0.7 )
		fog=display.newImageRect( "sea.jpg", display.actualContentWidth, display.actualContentHeight )
		fog.anchorX = 0
		fog.anchorY = 0
		fog.x = 0 + display.screenOriginX
		fog.y = 0 + display.screenOriginY
		fog:setFillColor(1,1,1)
        fog.alpha=0.4
        pauseBtn:toFront()
        backBtn:toFront()
		backworld:removeEventListener( "touch", onSceneTouch )
        timer.pause(timerNewFish)
        timer.pause(countdownTimer)
		physics.pause()
		pause,press=true, false
	end
end
local function onOkBtnRelease()
	audio.play(click, {channel = 2})
	timer.resume( timerNewFish )
    backworld:addEventListener( "touch", onSceneTouch )
    Runtime:addEventListener("enterFrame", enterFrame)
	display.remove(fog)
	world:remove( okBtn )
	backBtn:toFront()
	backBtn:setEnabled(true)
	pauseBtn:toFront()
    pauseBtn:setEnabled(true)
    startCountdown()

end


function scene:create( event )
	local sceneGroup = self.view

	loadScores()
	loadTutorial()


  if composer.getVariable( "sound" ) then
  	audio.setVolume(0.5, {channel=1})
  	audio.setVolume(1, {channel=2})
  	audio.setVolume(1, {channel=3})
	audio.setVolume(1, {channel=4})

  else
  	audio.setVolume(0, {channel=1})
  	audio.setVolume(0, {channel=2})
  	audio.setVolume(0, {channel=3})
	audio.setVolume(0, {channel=4})

  end
  backBtn = widget.newButton{
	textOnly=true,
    label="Back",
    font="Herculanum",
	labelColor = { over={ 0, 0, 0 }, default={ 1, 1, 1, 1 } },
	default="button.png",
	over="button-over.png",
	width=200, height=50,
	onRelease = onBackBtnRelease	-- event listener function
}
backBtn.x = display.contentCenterX*0.2
backBtn.y = display.contentCenterY-display.contentCenterY
pauseBtn = widget.newButton{
	textOnly=true,
    label="Pause",
    font="Herculanum",
	labelColor = { over={ 0, 0, 0 }, default={ 1, 1, 1, 1 } },
	default="button.png",
	over="button-over.png",
	width=200, height=50,
	onRelease = onPauseBtnRelease	-- event listener function
}
pauseBtn.x = display.contentCenterX*1.8
pauseBtn.y = display.contentCenterY-display.contentCenterY


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
    sceneGroup:insert( pauseBtn )
    sceneGroup:insert( backBtn )
    sceneGroup:insert( score )
	sceneGroup:insert( record )


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
        if tutorial[1] then
			fog=display.newImageRect( "tutorial.png", display.actualContentWidth, display.actualContentHeight )
			fog.anchorX = 0
			fog.anchorY = 0
			fog.x = 0 + display.screenOriginX
			fog.y = 0 + display.screenOriginY
			fog:setFillColor(1.0,1.0,1.0)
			fog.alpha=1.0
            backworld:removeEventListener("touch", onSceneTouch)
            Runtime:removeEventListener("enterFrame", enterFrame)
			timer.pause(timerNewFish)
			pauseBtn:toBack()
			pauseBtn:setEnabled(false)
			backBtn:toBack()
			backBtn:setEnabled(false)
			okBtn= widget.newButton{
			textOnly=true,
            label="Ok!",
            font="Herculanum",
			labelColor = { over={ 0, 0, 0 }, default={ 1, 1, 1, 1 } },
			default="button.png",
			over="button-over.png",
			width=200, height=50,
			onRelease = onOkBtnRelease	-- event listener function
			}
			okBtn.x = display.contentCenterX
            okBtn.y = display.contentCenterY
            world:insert( okBtn )
            okBtn:toFront()
			loadTutorial()
			table.insert( tutorial, 1, false )
            saveTutorial()
        else startCountdown()
		end

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
    if backBtn then
		backBtn:removeSelf()	-- widgets must be manually removed
		backBtn = nil
		pauseBtn:removeSelf()	-- widgets must be manually removed
		pauseBtn = nil
	end

	audio.dispose(crack)
	crack=nil
	audio.dispose( splash )
	audio.dispose( click )
	click=nil
	splash=nil

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