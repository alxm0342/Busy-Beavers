-----------------------------------------------------------------------------------------
--
-- level2_complete.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

local storyboard = require( "storyboard" )
local twigs = require("assets.twigs")
local scene = storyboard.newScene()
local lvlTimer = require("assets.level_timer")

----------------------------------------
-- Handles scene creation event
----------------------------------------
function scene:createScene( event )
	local group = self.view
	local bg = display.newImage("media/level2_complete.jpg")
	
	local scoreText = display.newText("Score:",30,130, native.systemFontBold, 25)
	local scoreDisplay = display.newText(twigs.getScore(),180,130,native.systemFontBold, 25)
	local timeText = display.newText("Time:",30,160, native.systemFontBold, 25)
	local xText = display.newText("x",155,160,native.systemFontBold,25)
	local timeDisplay = display.newText(lvlTimer.getTime(),180,160,native.systemFontBold, 25)
	local addLine = display.newText("__________________",30,170,native.systemFontBold, 25)
	local totalText = display.newText("L2 Total:",30,210, native.systemFontBold, 25)
	local totalDisplay = display.newText(lvlTimer.getMultipliedTime(),180,210, native.systemFontBold, 25)
	
	local totalText2 = display.newText("L1 Total:",30,240, native.systemFontBold, 25)
	local plusText2 = display.newText("+",155,240,native.systemFontBold,25)
	local totalDisplay2 = display.newText(twigs.getL1Score(),180,240,native.systemFontBold, 25)
	local addLine2 = display.newText("__________________",30,250,native.systemFontBold, 25)
	local totalText3 = display.newText("Total:",30,290, native.systemFontBold, 25)
	local totalDisplay3 = display.newText(twigs.getL1Score() + lvlTimer.getMultipliedTime(),180,290, native.systemFontBold, 25)
	
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
	group:insert(totalText2)
	group:insert(plusText2)
	group:insert(totalDisplay2)
	group:insert(addLine2)
	group:insert(totalText3)
	group:insert(totalDisplay3)
	
end

----------------------------------------
-- Handles scene entrance event
----------------------------------------
function scene:enterScene( event )
	storyboard.purgeScene("assets.level2")
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
			storyboard.gotoScene("assets.credit_screen", "fade", 200)
		end
	end 
end

scene:addEventListener("createScene", scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener("destroyScene", scene)

return scene