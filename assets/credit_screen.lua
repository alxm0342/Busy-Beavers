-----------------------------------------------------------------------------------------
--
-- credit_screen.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------
-- Handles scene creation event
----------------------------------------
function scene:createScene( event )
	local group = self.view
	local bg = display.newImage("media/credits.jpg")
	
	group:insert(bg)
end

----------------------------------------
-- Handles scene entrance event
----------------------------------------
function scene:enterScene( event )
	storyboard.purgeScene("assets.level2_complete")
	Runtime:addEventListener("touch", touch)
end

----------------------------------------
-- Handles scene exit event
----------------------------------------
function scene:exitScene( event )
	Runtime:removeEventListener("touch", touch)
end

----------------------------------------
-- Handles scene destruction event
----------------------------------------
function scene:destroyScene( event)
	-- No code needed
end

-----------------------------------------------
-- Handles touch events
-----------------------------------------------
function touch(event)
	if event.phase == "began"then
		storyboard.gotoScene("assets.main_menu", "fade", 200)
	end
end

scene:addEventListener("createScene", scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener("destroyScene", scene)

return scene