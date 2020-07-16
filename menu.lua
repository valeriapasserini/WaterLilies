local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local bestScore
if composer.getVariable( "sound" )==nil then
	composer.setVariable( "sound",true )
end

-- include Corona's "widget" library
local widget = require "widget"

local sound= require "sound"

local json = require( "json" )

local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local tutorial={}
local filePath2 = system.pathForFile( "tutorial.json", system.DocumentsDirectory )

local playBtn
local highBtn
local tutorialBtn
local soundBtn
local world=display.newGroup()
local frog= require('frog')
local waterlilie= require('waterlilie')
local waterlilies=display.newGroup()
local backworld= display.newGroup()
local fishes = display.newGroup()
local fish=require('fish')
local waterlilie_main=waterlilie
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local click = audio.loadSound( "click.mp3" )

--------------------------------------------

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


local function loadTutorial()
local file = io.open( filePath2, "r" )

if file then
	local contents = file:read( "*a" )
		io.close( file )
		tutorial = json.decode( contents )
end

if ( tutorial == nil or #tutorial == 0) then
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

local function onPlayBtnRelease()
	audio.play(click, {channel = 2})
	audio.stop(1)
	timer.cancel(timerNewFish)
	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "game", "fade", 400 )
	return true	-- indicates successful touch
end

local function onTutorialBtnRelease()
	audio.play(click, {channel = 2})
	audio.stop(1)

	-- go to game.lua scene
	loadTutorial()
	table.insert( tutorial, 1, true )
	saveTutorial()
	timer.cancel(timerNewFish)
	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "game", "fade", 400 )
	return true	-- indicates successful touch
end

local function onHighBtnRelease()
    audio.play(click, {channel = 2})
    audio.stop(1)
	timer.cancel(timerNewFish)
	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "highScores", "fade", 400 )
	return true	-- indicates successful touch
end

local function onSoundBtnRelease(event)

	if composer.getVariable( "sound" ) then
		composer.setVariable( "sound", false )
		soundBtn:setSequence("soundOff")

		soundBtn.defaultFile="speakerOff.png"
	else
		audio.play(click, {channel = 2})
		composer.setVariable( "sound", true )
		soundBtn:setSequence("soundOn")


		soundBtn.defaultFile="speaker.png"


	end
end

local function onInfoBtnRelease(event)
	audio.play(click, {channel = 2})
	timer.cancel(timerNewFish)
	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "info", "fade", 400 )
end
local function newFish(event)
	fish.new(fishes, (math.random(1,2)-1)*screenW, math.random(frog.y-display.actualContentHeight/2,frog.y), display.actualContentWidth/4,display.actualContentWidth/4)
	timerNewFish=timer.performWithDelay( math.random(1,4)*500, newFish )
end

local function offScreen(object)
	local bounds = object.contentBounds
	local sox = display.screenOriginX
	if bounds.xMax < sox then return true end
	if bounds.xMin > display.actualContentWidth - sox then return true end
	return false
end

local function enterFrame(event)

	if composer.getVariable( "sound" ) then
		audio.play(music, {channel=1, loops=-1})
		audio.setVolume(0.5, {channel=1})
		audio.setVolume(1, {channel=2})
		audio.setVolume(1, {channel=3})
	else
		audio.setVolume(0, {channel=1})
		audio.setVolume(0, {channel=2})
		audio.setVolume(0, {channel=3})
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
end

function scene:create( event )
	local sceneGroup = self.view
	loadScores()
	loadTutorial()
	composer.setVariable( "record", scoresTable[1] )
	--audio.play(music, {channel=1, loops=-1})

	-- Called when the scene's view does not exist.


	-- display a background image
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
	local pos={1,2,3,4}
	local xstart=math.random(#pos)*(display.actualContentWidth/4)-(display.actualContentWidth/8)
	frog=frog.new(world, xstart,  display.contentCenterY+150, display.actualContentWidth/4, display.actualContentWidth/4 )
	waterlilie_main=waterlilie.new(world, xstart,  display.contentCenterY+150, display.actualContentWidth/4, display.actualContentWidth/4 )
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

	world:insert(fishes)
	world:insert(waterlilies)
	world:insert(waterlilie_main)
	world:insert(frog)
	sceneGroup:insert(backworld)

	sceneGroup:insert(world)

	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo2.png", 250, 90 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = display.contentCenterY*0.8



	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		textOnly=true,
        label="Play",
        font="Herculanum",
		labelColor = { over={ 0, 0, 0 }, default={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentCenterY

	highBtn = widget.newButton{
		textOnly=true,
        label="High Scores",
        font="Herculanum",
		labelColor = { over={ 0, 0, 0 }, default={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onHighBtnRelease	-- event listener function
	}
	highBtn.x = display.contentCenterX
	highBtn.y = display.contentCenterY*1.15

	tutorialBtn = widget.newButton{
		textOnly=true,
        label="Tutorial",
        font="Herculanum",
		labelColor = { over={ 0, 0, 0 }, default={ 1, 1, 1, 1 } },
		default="button.png",
		over="button-over.png",
		width=200, height=50,
		onRelease = onTutorialBtnRelease	-- event listener function
	}
	tutorialBtn.x = display.contentCenterX
	tutorialBtn.y = display.contentCenterY*1.3

	soundBtn=sound.new(sceneGroup,display.contentCenterX*1.8,display.contentCenterY-display.contentCenterY)
	soundBtn.alpha=1

  infoBtn=display.newImageRect(sceneGroup,"info.png", 24,24)
	infoBtn.x,infoBtn.y=display.contentCenterX*0.2, display.contentCenterY-display.contentCenterY
	infoBtn.alpha=1


	-- all display objects must be inserted into group

	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( highBtn )
	sceneGroup:insert( tutorialBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then

	soundBtn:toFront()
	infoBtn:toFront()


	elseif phase == "did" then
		if composer.getVariable("sound") then
			soundBtn.filename="speaker.png"
		else
			soundBtn.filename="speaker-off.png"
		end
		timerNewFish=timer.performWithDelay( math.random(1,2)*2000, newFish )
		Runtime:addEventListener("enterFrame", enterFrame)
		soundBtn:addEventListener("tap", onSoundBtnRelease)
		infoBtn:addEventListener("tap", onInfoBtnRelease)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		timer.cancel(timerNewFish)


	elseif phase == "did" then
		-- Called when the scene is now off screen
		Runtime:removeEventListener("enterFrame", enterFrame)
		soundBtn:removeEventListener("tap", onSoundBtnRelease)
		infoBtn:removeEventListener("tap", onInfoBtnRelease)

		composer.removeScene("menu")

	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	audio.dispose(click)
	click=nil
	display.remove(soundBtn)

	Runtime:removeEventListener("enterFrame", enterFrame)
	soundBtn:removeEventListener("tap", onSoundBtnRelease)


	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if highBtn then
		highBtn:removeSelf()	-- widgets must be manually removed
		highBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene