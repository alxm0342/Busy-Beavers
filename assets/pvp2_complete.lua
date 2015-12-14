-----------------------------------------------------------------------------------------
--
-- pvp2_complete.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local twigs = require("assets.twigs")

----------------------------------------
-- Handles scene creation event
----------------------------------------
function scene:createScene( event )
	local group = self.view
	local bg = display.newImage("media/pvplevel_complete.jpg")
	
	local p1ScoreText = display.newText("Player 1 Score:", 30, 200, native.systemFontBold, 20)
	local p1ScoreDisplay = display.newText(twigs.getP1Score(),200,200,native.systemFontBold, 20)
	local p2ScoreText = display.newText("Player 2 Score:", 30, 230, native.systemFontBold, 20)
	local p2ScoreDisplay = display.newText(twigs.getP2Score(),200,230,native.systemFontBold, 20)
	
	group:insert(bg)
	group:insert(p1ScoreText)
	group:insert(p1ScoreDisplay)
	group:insert(p2ScoreText)
	group:insert(p2ScoreDisplay)
	
end

----------------------------------------
-- Handles scene entrance event
----------------------------------------
function scene:enterScene( event )
	storyboard.purgeScene("assets.pvp2")
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
			local twigs = require("assets.twigs")
			twigs.resetScore()
			twigs.resetP1Score()
			twigs.resetP2Score()
			twigs = nil
			storyboard.gotoScene("assets.credit_screen", "fade", 200)
		end
	end 
end

scene:addEventListener("createScene", scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener("destroyScene", scene)

return scene