-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )
composer.setVariable("sound",true)
sound = composer.getVariable("sound")

if (audio.isChannelPlaying(1)) then
	sound = true
end

if (audio.isChannelPlaying(1) == false) then
	sound = false
end


