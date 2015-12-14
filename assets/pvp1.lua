-----------------------------------------------------------------------------------------
--
-- pvp1.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

local storyboard = require("storyboard")
local scene = storyboard.newScene()
local platforms = require("assets.platforms")
local twigs = require("assets.twigs")
local paused = false
local lvlTimer = require("assets.level_timer")
local p1ScoreDisplay
local p1ScoreText
local p2ScoreDisplay
local p2ScoreText
local timeDisplay
local movement
local countdown
local menu
local help1
local help2
local game_options = require("assets.game_options")
local options
local on1
local on2
local on3
local off1
local off2
local off3
local screenGroup
local background
local statusBar
local beginX
local beginY
local endX
local endY
local xDistance
local yDistance
local group

----------------------------------------
-- Handles scene creation event
----------------------------------------
function scene:createScene( event )
	group = self.view
	
	background = display.newImage("media/background.jpg")
	movement = require("assets.movement")
	statusBar = display.newImage("media/statusbar.jpg")
	menuButton = display.newImage("media/menu_button.png", 136, 466)
	timeDisplay = display.newText("Start!", 286, 465, native.systemFontBold, 12)
	p1ScoreText = display.newText("P1:", 10, 465, native.systemFontBold, 12)
	p1ScoreDisplay = display.newText(twigs.getScore(),40,465,native.systemFontBold,12)
	p2ScoreText = display.newText("P2:", 80, 465, native.systemFontBold, 12)
	p2ScoreDisplay = display.newText(twigs.getP2Score(),110,465,native.systemFontBold,12)
	menu = display.newImage("media/ingame_menu_2p.png", 0, 0)
	help1 = display.newImage("media/help_pg1.png", 0,0)
	help2 = display.newImage("media/help_pg2_2p.png",0,0)
	options = display.newImage("media/options.png",0,0)
	on1 = display.newImage("media/on_button.png",205,130)
	on2 = display.newImage("media/on_button.png",205,175)
	on3 = display.newImage("media/on_button.png",205,220)
	off1 = display.newImage("media/off_button.png",205,130)
	off2 = display.newImage("media/off_button.png",205,175)
	off3 = display.newImage("media/off_button.png",205,220)

	menu.isVisible = false
	help1.isVisible = false
	help2.isVisible = false
	options.isVisible = false
	on1.isVisible = false
	on2.isVisible = false
	on3.isVisible = false
	off1.isVisible = false
	off2.isVisible = false
	off3.isVisible = false
	statusBar.y = 473
	
	group:insert(background)
	group:insert(platforms.loadPlatforms())
	group:insert(twigs.loadTwigs(true))
	group:insert(movement.load(1))
	group:insert(statusBar)
	group:insert(menuButton)
	group:insert(timeDisplay)
	group:insert(p1ScoreDisplay)
	group:insert(p1ScoreText)
	group:insert(p2ScoreDisplay)
	group:insert(p2ScoreText)
	group:insert(menu)
	group:insert(help1)
	group:insert(help2)
	group:insert(options)
	group:insert(on1)
	group:insert(on2)
	group:insert(on3)
	group:insert(off1)
	group:insert(off2)
	group:insert(off3)
end

----------------------------------------
-- Handles scene entrance event
----------------------------------------
function scene:enterScene( event )
	pvp1Music = audio.loadStream("media/music/level1.mp3")
	if (game_options.getMusic() == 'on') then
		pvp1MusicChannel = audio.play(pvp1Music, {loops=-1})
	end
	local p1Start = display.newImage("media/p1Start.png")
	timer.performWithDelay(2000, function()
		p1Start:removeSelf()
		p1Start = nil
	end, 1)
	paused = false
	group.isVisible = true
	menu.isVisible = false
	countdown = timer.performWithDelay(1000,
		function()
			lvlTimer.decrementTime()
			timeDisplay.text = lvlTimer.getTime()
			p1ScoreDisplay.text = twigs.getScore()
			if (lvlTimer.getTime()-90 == 0)  then
				lvlTimer.resetTime()
				twigs.saveP1Score()
				twigs.resetScore()
				storyboard.gotoScene("assets.pvp1_complete")
			end
		end, 0)
	Runtime:addEventListener("touch", swipe)
	Runtime:addEventListener("touch", touch)
end

----------------------------------------
-- Handles scene exit event
----------------------------------------
function scene:exitScene( event )
	audio.stop(pvp1MusicChannel)
	pvp1MusicChannel = nil
	pvp1Music = nil
	timer.cancel(countdown)
	countdown = nil
	Runtime:removeEventListener("touch", swipe)
	Runtime:removeEventListener("touch", touch)
	movement.unload()
	platforms.unloadPlatforms()
	twigs.unloadTwigs()
	movement.initialPosition()
	collectgarbage('collect')
end

----------------------------------------
-- Handles scene destruction event
----------------------------------------
function scene:destroyScene( event)
	--No code needed
end

----------------------------------------
-- Start the platform engine
----------------------------------------
function startPlatforms()
	platforms.loadPlatforms()
end

-----------------------------------------------
-- Swipe event definition
-----------------------------------------------
function swipe(event)
	if event.phase == "began" then
		beginX = event.x
		beginY = event.y
	end

	if event.phase == "ended" then
		endX = event.x
		endY = event.y
		checkSwipeDirection();
	end
end

-----------------------------------------------
-- Checks which direction user swiped
-----------------------------------------------
function checkSwipeDirection()
	if pcall(function()
		xDistance = math.abs(endX - beginX)
		yDistance = math.abs(endY - beginY)
		end) then
	else
		xDistance = 0
		yDistance = 0
	end

	if paused == false then
		if xDistance > yDistance then
			if xDistance > 8 then
				if beginX > endX then
					movement.moveBeaver("x", movement.getBeaverX()-52.00);
				else
					movement.moveBeaver("x", movement.getBeaverX()+52.00);
				end
			end
		else
			if yDistance > 8 then
				if beginY > endY then
					movement.moveBeaver("y", movement.getBeaverY()-52.27);
				else
					movement.moveBeaver("y", movement.getBeaverY()+52.27);
				end
			end
		end
	end
end

-----------------------------------------------
-- Handles touch events
-----------------------------------------------
function touch(event)

	if event.phase == "began" then
		print(event.x)
		print(event.y)

		if paused == true then
			--resume button
			if event.x > 100 and event.x < 220 and event.y > 80 and event.y < 108 then
				movement.resume()
				paused = false
				menu.isVisible = false
				timer.resume(countdown)
			--exit level button
			elseif event.x > 100 and event.x < 220 and event.y > 302 and event.y < 332 and menu.isVisible == true then
				lvlTimer.resetTime()
				twigs.resetScore()
				twigs.resetP1Score()
				twigs.resetP2Score()
				storyboard.gotoScene("assets.main_menu", "fade", 200)
			--help back button
			elseif event.x > 100 and event.x < 220 and event.y > 302 and event.y < 332 and help1.isVisible == true then
				help1.isVisible = false
				menu.isVisible = true
			--help back button
			elseif event.x > 100 and event.x < 220 and event.y > 302 and event.y < 332 and help2.isVisible == true then
				help2.isVisible = false
				menu.isVisible = true
			--help1 to help2 arrow button
			elseif event.x > 255 and event.x < 270 and event.y > 130 and event.y < 210 and help1.isVisible == true then
				help1.isVisible = false
				help2.isVisible = true
			--help2 to help1 arrow button
			elseif event.x > 50 and event.x < 65 and event.y > 130 and event.y < 210 and help2.isVisible == true then
				help1.isVisible = true
				help2.isVisible = false
			--help button
			elseif event.x > 100 and event.x < 220 and event.y > 255 and event.y < 275 then
				menu.isVisible = false
				help1.isVisible = true
			--options button
			elseif event.x > 100 and event.x < 220 and event.y > 220 and event.y < 250 and menu.isVisible == true  then
				menu.isVisible = false
				options.isVisible = true
				if (game_options.getMusic() == 'on') then
					on1.isVisible = true
					game_options.setMusicOn()
				else
					off1.isVisible = true
					game_options.setMusicOff()
					audio.stop()
				end
				if (game_options.getSound() == 'on') then
					on2.isVisible = true
					game_options.setSoundOn()
				else
					off2.isVisible = true
					game_options.setSoundOff()
				end
				if (game_options.getVibrate() == 'on') then
					on3.isVisible = true
					game_options.setVibrateOn()
				else
					off3.isVisible = true
					game_options.setVibrateOff()
				end

			--options back button
			elseif event.x > 100 and event.x < 220 and event.y > 302 and event.y < 332 and options.isVisible == true then
				options.isVisible = false
				on1.isVisible = false
				off1.isVisible = false
				on2.isVisible = false
				off2.isVisible = false
				on3.isVisible = false
				off3.isVisible = false
				menu.isVisible = true
			--on/off buttons in options
			elseif event.x > 205 and event.x < 270 and event.y > 130 and event.y < 150 and options.isVisible == true then	
				--Music
				if(game_options.getMusic() == 'on') then
					on1.isVisible = false
					off1.isVisible = true
					game_options.setMusicOff()
					audio.stop()
				else
					off1.isVisible = false
					on1.isVisible = true
					game_options.setMusicOn()
					pvp1MusicChannel = audio.play(pvp1Music, {loops=-1})
				end	
			elseif event.x > 205 and event.x < 270 and event.y > 175 and event.y < 195 and options.isVisible == true then
				--Sound effects
				if(game_options.getSound() == 'on') then
					on2.isVisible = false
					off2.isVisible = true
					game_options.setSoundOff()
				else
					off2.isVisible = false
					on2.isVisible = true
					game_options.setSoundOn()
				end	
			elseif event.x > 205 and event.x < 270 and event.y > 220 and event.y < 250 and options.isVisible == true then
				--Vibration
				if(game_options.getVibrate() == 'on') then
					on3.isVisible = false
					off3.isVisible = true
					game_options.setVibrateOff()
				else
					off3.isVisible = false
					on3.isVisible = true
					game_options.setVibrateOn()
				end	
			end
		else
			--Menu
			if event.x > 138 and event.x < 182 and event.y > 466 then
				movement.pause()
				timer.pause(countdown)
				paused = true
				menu.isVisible = true
			end
		end
	end
end

----------------------------------------

print("loading pvp1.lua")

scene:addEventListener("createScene", scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener("destroyScene", scene)

return scene
