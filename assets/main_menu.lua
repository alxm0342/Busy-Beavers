-----------------------------------------------------------------------------------------
--
-- main_menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local game_options = require("assets.game_options")
local gameState = require("assets.saveLoad")
local gameSettings = {}
local bg, logo, options
local kioskTimer
local kioskNo = 1

----------------------------------------
-- Handles scene creation event
----------------------------------------
function scene:createScene( event )
	local group = self.view

	bg = display.newImage("media/main_menu_background.jpg")	
	logo = display.newImage("media/bb.png", 5, -130)
	options = display.newImage("media/menu.png", 30, 480)

	timer.performWithDelay( 1500,
		function()
			transition.to(logo, {time=200, y=65})
		end, 1)

	timer.performWithDelay( 2000,
		function()
			transition.to(options, {time=250, y=314})
			storyboard.purgeScene( "assets.splash_screen" )
		end, 1)

	group:insert(bg)
	group:insert(logo)
	group:insert(options)

end

----------------------------------------
-- Handles scene entrance event
----------------------------------------
function scene:enterScene( event )
    kioskTimer = timer.performWithDelay(10000,
        function()
                if kioskNo > 0 then
                    kioskNo = kioskNo*-1
                    storyboard.gotoScene("assets.kiosk1", "fade", 200)
                else
					kioskNo = kioskNo*-1
                    storyboard.gotoScene("assets.kiosk2", "fade", 200)
                end
        end, 1)
	menuMusic = audio.loadStream("media/music/mainMenu.mp3")
	if (game_options.getMusic() == 'on') then
		menuMusicChannel = audio.play(menuMusic, {loops=-1})
	end
	storyboard.purgeScene("assets.credit_screen")
	storyboard.purgeScene("assets.kiosk1")
	storyboard.purgeScene("assets.kiosk2")
	storyboard.purgeScene("assets.level1")
	storyboard.purgeScene("assets.level1_saved")
	storyboard.purgeScene("assets.level1_complete")
	storyboard.purgeScene("assets.level2")
	storyboard.purgeScene("assets.level2_saved")
	storyboard.purgeScene("assets.level2_complete")
	storyboard.purgeScene("assets.pvp1")
	storyboard.purgeScene("assets.pvp2")
	Runtime:addEventListener("touch", touch)
end

----------------------------------------
-- Handles scene exit event
----------------------------------------
function scene:exitScene( event )
	timer.cancel(kioskTimer)
	kioskTimer = nil
	audio.stop(menuMusicChannel)
	menuMusicChannel = nil
	menuMusic = nil
	Runtime:removeEventListener("touch", touch)
end

----------------------------------------
-- Handles scene destruction event
----------------------------------------
function scene:destroyScene( event)
	bg:removeSelf()
	logo:removeSelf()
	options:removeSelf()
end

-----------------------------------------------
-- Handles touch events
-----------------------------------------------
function touch(event)

	if event.phase == "began" then
		print(event.x)
		print(event.y)
		
		if event.x > 45 and event.x < 250 then
			if event.y > 145 and event.y < 210 then
				storyboard.gotoScene("assets.level1", "fade", 200)
			elseif event.y > 232 and event.y < 320 then
				gameSettings = gameState.loadTable("gamesettings.json")
				if gameSettings.level1 == true then
					storyboard.purgeScene("assets.level1_saved")
					storyboard.purgeScene("assets.level2_saved")
					storyboard.gotoScene("assets.level1_saved", "fade", 200)
				elseif gameSettings.level2 == true then
					storyboard.purgeScene("assets.level1_saved")
					storyboard.purgeScene("assets.level2_saved")
					storyboard.gotoScene("assets.level2_saved", "fade", 200)
				end
				print("game loaded")
			elseif event.y > 335 and event.y < 400 then
				storyboard.gotoScene("assets.pvp1", "fade", 400)
			elseif event.y > 408 and event.y < 470 then
				os.exit()
			end
		end
	end 

end

------------------------------------------------

scene:addEventListener("createScene", scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener("destroyScene", scene)

return scene