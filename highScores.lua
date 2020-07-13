local composer = require( "composer" )

local scene = composer.newScene()
local widget = require "widget"
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local click = audio.loadSound( "click.mp3" )

local world=display.newGroup()
local frog= require('frog')
local waterlilie= require('waterlilie')
local waterlilies=display.newGroup()
local backworld= display.newGroup()
local fishes = display.newGroup()
local fish=require('fish')
local waterlilie_main=waterlilie

if composer.getVariable( "sound" )==nil then
	composer.setVariable( "sound",true )
end

-- Initialize variables
local json = require( "json" )
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

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


function scene:create( event )
    local sceneGroup = self.view

    if composer.getVariable( "sound" ) then
    	audio.setVolume(0.5, {channel=1})
    	audio.setVolume(1, {channel=2})
    else
    	audio.setVolume(0, {channel=1})
    	audio.setVolume(0, {channel=2})
    end

    -- Code here runs when the scene is first created but has not yet appeared on screen
    -- Load the previous scores
    loadScores()
    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )
    -- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )
    -- Save the scores
    saveScores()
    composer.setVariable( "record", scoresTable[1] )

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

    local highScoresHeader = display.newText( sceneGroup, "highScores:", display.contentCenterX, display.contentCenterY*0.7, "Herculanum", 44 )
    highScoresHeader:setFillColor(1,1,1)

    for i = 1, 3 do
           if ( scoresTable[i] ) then
                local yPos = display.contentCenterY*0.7 + ( i * 56 )
                local rankNum = display.newText( sceneGroup, i .. ") ".. scoresTable[i], display.contentCenterX, yPos, "Herculanum", 30 )
                rankNum:setFillColor(1,1,1)
            end
    end

    local function onBackBtnRelease()
        -- go to game.lua scene
        audio.play(click, {channel=2})
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
