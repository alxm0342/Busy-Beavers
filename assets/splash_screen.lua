-----------------------------------------------------------------------------------------
--
-- splash_screen.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local splash

----------------------------------------
-- Handles scene creation event
----------------------------------------
function scene:createScene( event )

	local group = self.view

	print("loading splash_screen.lua")	

	splash = display.newImage("media/splash.jpg", 0, 0)
	
	local j=0
	
	timer.performWithDelay( 500,
		function()
			local loadTxt
			if j==0 then
				loadTxt = display.newImage("media/loading.png", 0, 0)
				j = j+1
			elseif j==1 then
				loadTxt = display.newImage("media/loading1.png", 0, 0)
				j = j+1
			elseif j==2 then
				loadTxt = display.newImage("media/loading2.png", 0, 0)
				j = j+1
			else
				loadTxt = display.newImage("media/loading3.png", 0, 0)
				j = 0
			end
			timer.performWithDelay( 500,
				function()
					loadTxt:removeSelf()
				end, 1 )
		end, 12 )

	group:insert(splash)
end

----------------------------------------
-- Handles scene entrance event
----------------------------------------
function scene:enterScene( event )
	-- No code needed
end

----------------------------------------
-- Handles scene exit event
----------------------------------------
function scene:exitScene( event )
	-- No code needed
end

----------------------------------------
-- Handles scene destruction event
----------------------------------------
function scene:destroyScene( event)
	--splash:removeSelf()
end

scene:addEventListener("createScene", scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener("destroyScene", scene)

return scene