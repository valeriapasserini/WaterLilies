local composer = require( "composer" )
local scene = composer.newScene()



-- include Corona's "widget" library
local widget = require "widget"


local playBtn
local highBtn
local tutorialBtn
local soundBtn

local waterlilie_main=waterlilie
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

--------------------------------------------


local function onPlayBtnRelease()

	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "game", "fade", 400 )
	return true	-- indicates successful touch
end

local function onTutorialBtnRelease()

	-- go to game.lua scene

	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "game", "fade", 400 )
	return true	-- indicates successful touch
end

local function onHighBtnRelease()


	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "highScores", "fade", 400 )
	return true	-- indicates successful touch
end

local function onSoundBtnRelease(event)


end

local function onInfoBtnRelease(event)

	Runtime:removeEventListener("enterFrame", enterFrame)
	composer.removeScene( "menu")
	composer.gotoScene( "info", "fade", 400 )
end




local function enterFrame(event)




end

function scene:create( event )
	local sceneGroup = self.view



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
	backworld:insert(background)
	backworld:insert(sea)


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