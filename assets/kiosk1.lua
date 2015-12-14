-----------------------------------------------------------------------------------------
--
-- kiosk1.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)

local storyboard = require("storyboard")
local scene = storyboard.newScene()
local platforms = require("assets.platforms")
local twigs = require("assets.twigs")
local scoreDisplay
local scoreText
local kioskModeDisplay
local tapDisplay
local movement
local x
local y
local z
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
local automation
local moveTimers = {}

----------------------------------------
-- Handles scene creation event
----------------------------------------
function scene:createScene( event )
	group = self.view
	
	background = display.newImage("media/background.jpg")
	movement = require("assets.movement")
	statusBar = display.newImage("media/statusbar.jpg")
	kioskModeDisplay = display.newText("Kiosk Mode: Tap to Exit", 186, 465, native.systemFontBold, 12)
	tapDisplay = display.newImage("media/kiosk.png")
	tapDisplay.isVisible = false
	scoreText = display.newText("Score:", 10, 465, native.systemFontBold, 12)
	scoreDisplay = display.newText(twigs.getScore(),60,465,native.systemFontBold,12)
	
	x = 1
	y = 1
	z = 1
	statusBar.y = 473
	
	group:insert(background)
	group:insert(platforms.loadPlatforms())
	group:insert(twigs.loadTwigs(false))
	group:insert(movement.load(1))
	group:insert(statusBar)
	group:insert(kioskModeDisplay)
	group:insert(scoreDisplay)
	group:insert(scoreText)
	group:insert(tapDisplay)
end

----------------------------------------
-- Handles scene entrance event
----------------------------------------
function scene:enterScene( event )
	level1Music = audio.loadStream("media/music/level1.mp3")
	level1MusicChannel = audio.play(level1Music, {loops=-1})
	group.isVisible = true
	countdown = timer.performWithDelay(1000,
		function()
			scoreDisplay.text = twigs.getScore()
		end, 0)
	Runtime:addEventListener("touch", touch)
	
	kioskScript()
	
	--Insert the flashing "tap to exit" image
	table.insert(moveTimers, timer.performWithDelay(1200,
		function()
			if tapDisplay.isVisible == false then
				tapDisplay.isVisible = true
			else
				tapDisplay.isVisible = false
			end
		end, 0))
end

----------------------------------------
-- Handles scene exit event
----------------------------------------
function scene:exitScene( event )
	audio.stop(level1MusicChannel)
	level1MusicChannel = nil
	level1Music = nil
	timer.cancel(countdown)
	table.foreach(moveTimers, function(k)
		timer.cancel(moveTimers[k])
		end)
	countdown = nil
	Runtime:removeEventListener("touch", touch)
	movement.unload()
	platforms.unloadPlatforms()
	twigs.resetScore()
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

----------------------------------------
-- Auto scoring script
----------------------------------------
function kioskScript()
	table.insert(moveTimers, timer.performWithDelay(4500,
		function()
			moveUp() -- gets to row 7
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(5000,
		function()
			moveRight()
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(5500,
		function()
			moveRight()
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(6400,
		function()
			moveUp() --gets to row 6
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(6900,
		function()
			moveUp() -- get to row 5
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(7300,
		function()
			moveRight()
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(8500,
		function()
			moveUp() -- get to row 4
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(9500,
		function()
			moveUp() -- get to row 3
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(9900,
		function()
			moveUp() -- get to row 2
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(10300,
		function()
			moveRight()
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(12000,
		function()
			moveUp() -- get to row 1
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(12700,
		function()
			moveUp() -- get to twig
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(14100,
		function()
			moveUp() -- splash
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(15600,
		function()
			moveUp() -- get to row 7
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(16000,
		function()
			moveUp() -- get to row 6
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(16300,
		function()
			moveLeft() -- land on croc
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(18600,
		function()
			moveUp() -- get to row 7
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(19100,
		function()
			moveRight()
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(19600,
		function()
			moveRight()
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(20500,
		function()
			moveUp() --gets to row 6
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(21000,
		function()
			moveUp() -- get to row 5
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(21400,
		function()
			moveRight()
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(22600,
		function()
			moveUp() -- land on hippo
		end, 1))
	table.insert(moveTimers, timer.performWithDelay(25000,
		function()
			storyboard.gotoScene("assets.main_menu", "fade", 200) -- return to the main menu
		end, 1))	
		
end

-----------------------------------------------
-- Move beaver left
-----------------------------------------------
function moveLeft()
	movement.moveBeaver("x", movement.getBeaverX()-52.00);
end

-----------------------------------------------
-- Move beaver right
-----------------------------------------------
function moveRight()
	movement.moveBeaver("x", movement.getBeaverX()+52.00);
end

-----------------------------------------------
-- Move beaver up
-----------------------------------------------
function moveUp()
	movement.moveBeaver("y", movement.getBeaverY()-52.27);
end

-----------------------------------------------
-- Move beaver down
-----------------------------------------------
function moveDown()
	movement.moveBeaver("y", movement.getBeaverY()+52.27);
end

-----------------------------------------------
-- Handles touch events
-----------------------------------------------
function touch(event)
	if event.phase == "began" then
		print(event.x)
		print(event.y)
		storyboard.gotoScene("assets.main_menu", "fade", 200)
	end
end

----------------------------------------

print("loading kiosk1.lua")

scene:addEventListener("createScene", scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener("destroyScene", scene)

return scene
