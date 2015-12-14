-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

print("loading main.lua")

display.setStatusBar(display.HiddenStatusBar)

local storyboard = require "storyboard"

----------------------------------------
-- Initiate game sequence
----------------------------------------

-- Load the splash screen
 storyboard.gotoScene("assets.splash_screen", "fade", 400)

-- Enter the Main Menu
timer.performWithDelay( 6800,
	function()
		storyboard.gotoScene("assets.main_menu", "fade", 400)
	end, 1)

local monitorMem = function()

	collectgarbage()
	print( "MemUsage: " .. collectgarbage("count") )

	local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000    print( "TexMem:   " .. textMem )
end

Runtime:addEventListener( "enterFrame", monitorMem )

