-----------------------------------------------------------------------------------------
--
-- level1_complete.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local twigs = require("assets.twigs")
local lvlTimer = require("assets.level_timer")

----------------------------------------
-- Handles scene creation event
----------------------------------------
function scene:createScene( event )
	local group = self.view
	local bg = display.newImage("media/level1_complete.jpg")
	
	local scoreText = display.newText("Score:",30,170, native.systemFontBold, 25)
	local scoreDisplay = display.newText(twigs.getScore(),180,170,native.systemFontBold, 25)
	local timeText = display.newText("Time:",30,200, native.systemFontBold, 25)
	local xText = display.newText("x",155,200,native.systemFontBold,25)
	local timeDisplay = display.newText(lvlTimer.getTime(),180,200,native.systemFontBold, 25)
	local addLine = display.newText("__________________",30,210,native.systemFontBold, 25)
	local totalText = display.newText("Total:",30,250, native.systemFontBold, 25)
	local totalDisplay = display.newText(lvlTimer.getMultipliedTime(),180,250, native.systemFontBold, 25)
	
	twigs.setL1Score(lvlTimer.getMultipliedTime())
	twigs.resetScore()
	lvlTimer.resetTime()
	
	group:insert(bg)
	group:insert(scoreText)
	group:insert(scoreDisplay)
	group:insert(timeText)
	group:insert(xText)
	group:insert(timeDisplay)
	group:insert(addLine)
	group:insert(totalText)
	group:insert(totalDisplay)
	
end

----------------------------------------
-- Handles scene entrance event
----------------------------------------
function scene:enterScene( event )
	storyboard.purgeScene("assets.level1")
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
	if event.phase == "began" then
		if event.x > 100 and event.x < 218 and event.y > 404 and event.y < 434 then
			storyboard.gotoScene("assets.level2", "fade", 200)
		end
	end 
end

scene:addEventListener("createScene", scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener("destroyScene", scene)

return scene