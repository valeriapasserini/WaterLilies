local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"



function scene:create( event )
    local sceneGroup = self.view

    titleLogo = display.newImageRect(sceneGroup, "logo2.png", 250, 90 )
    titleLogo.x = display.contentCenterX
    titleLogo.y = display.contentCenterY*0.8

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

    author = display.newText( sceneGroup, "Authors:", display.contentCenterX, display.contentCenterY, "Herculanum", 15 )
    author.align="center"
    author:setFillColor(1,1,1)
    about1 = display.newText( sceneGroup, "Valeria Passerini", display.contentCenterX, display.contentCenterY*1.1, "Herculanum", 15 )
    about1.align="center"
    about1:setFillColor(1,1,1)
    about2 = display.newText( sceneGroup, "Giulia Martinini", display.contentCenterX, display.contentCenterY*1.2, "Herculanum", 15 )
    about2.align="center"
    about2:setFillColor(1,1,1)
    about3 = display.newText( sceneGroup, "Maria Ludovica Mallardo", display.contentCenterX, display.contentCenterY*1.3, "Herculanum", 15 )
    about3.align="center"
    about3:setFillColor(1,1,1)

    local function onBackBtnRelease()
        -- go to game.lua scene
        composer.removeScene( "highScores")
       	composer.gotoScene( "menu", "fade", 400 )
        return true	-- indicates successful touch
    end
    local backBtn = widget.newButton{
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

    sceneGroup:insert( titleLogo )

    sceneGroup:insert( backBtn )
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end


function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        composer.removeScene( "highScores" )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end


function scene:destroy( event )
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    audio.dispose(click)
    click=nil
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene