-----------------------------------------------------------------------------------------
--
-- movement.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)
local platforms = require('assets.platforms')
local twig = require('assets.twigs')
local physics = require('physics')
local level2 = require('assets.level2')
local game_options = require('assets.game_options')

local beaver
local safe = false
local inLevel2 = false
local rotation = 0

local splashSound
local jumpSound

----------------------------------------------
-- Load moving display objects
----------------------------------------------
function load(level)
	
	if (level==1) then
		beaver = display.newImage("media/beaver.png", 132, 420)
	else
		beaver = display.newImage("media/beaver_lvl2.png", 132, 420)
	end
	physics.start()
	beaver.shape = {-5,-15,5,-15,5,15,-5,15}
	beaver.twig = 0
	physics.addBody(beaver, 'dynamic',{shape = beaver.shape})
	beaver.isSensor = true
	beaver.force = 0
	
	splashSound = audio.loadSound("media/sounds/splash.mp3")
	jumpSound = audio.loadSound("media/sounds/jump.mp3")
	
	print("loading movement.lua")
	beaver:addEventListener("collision", platforms.onCollision)

	timer1 = timer.performWithDelay(100,
		function()
			if (beaver.x < -10 or beaver.x > 340) then
				initialPosition()
				if(inLevel2 == true) then
				end
			end
		end,0)
		
	return beaver
end

-----------------------------------------------
-- Unload sounds
-----------------------------------------------
function unload()
	timer.cancel(timer1)
	timer1 = nil
	splashSound = nil
	jumpSound = nil
end

-----------------------------------------------
-- Pause the game and display the menu
-----------------------------------------------
function pause()
	physics.pause()
	timer.pause(timer1)
	platforms.pausePlatforms()
	paused = true
end

-----------------------------------------------
-- Resume the game and hide the menu
-----------------------------------------------
function resume()
	platforms.resumePlatforms()
	timer.resume(timer1)
	physics.start()
	paused = false
end

-----------------------------------------------
-- Sets the beaver's initial position
-----------------------------------------------
function initialPosition()
	if pcall(function()
		if (game_options.getVibrate() == 'on') then
			system.vibrate()
		end
		stopForce()
		beaver.x = 162
		beaver.y = 450
		beaver:rotate(rotation*-1)
		rotation = 0
		safe = false
		end) then
	end
end

-----------------------------------------------
-- Moves the beaver within the screen limits
-----------------------------------------------
function moveBeaver(...)
	dir = arg[1]
	endPt = arg[2] 
	local accel = 35
	if dir == "x" then
		rotDir = 1
		if beaver.x > endPt then
			rotDir = -1
		end
		-- Handle moving in the same direction as the platform
		if beaver.x > endPt and beaver.force < 0 then
			endPt = endPt - accel
		elseif beaver.x < endPt and beaver.force > 0 then
			endPt = endPt + accel
		end
		if endPt < 325 and endPt > 0 then
			rotateBeaver(90)
			if (game_options.getSound() == 'on') then
				audio.play(jumpSound)
			end
			transition.to(beaver, {time=200, x=endPt, onComplete=
				function (obj)
					checkForSplash()
				end})
		end
	else
		rotDir = 2
		if beaver.y < endPt then
			rotDir = 1
		end
		if endPt < 480 and endPt > 0 then
			rotateBeaver(180)
			if (game_options.getSound() == 'on') then
				audio.play(jumpSound)
			end
			transition.to(beaver, {time=200, y=endPt, onComplete=
				function (obj)
					if (beaver.force ~= 0 and (endPt > 420 or endPt < 40 )) then
						beaver:applyForce(-(beaver.force),0,beaver.x,beaver.y)
						beaver.force = 0
					end	
					checkForSplash()
				end})
		end
	end
	safe=false
end

-----------------------------------------------
-- Rotate the beaver
-----------------------------------------------
function rotateBeaver(angle)
	if pcall(function()
		beaver:rotate(rotation*-1)
		rotation = rotDir*angle
		beaver:rotate(rotation)
	end) then
	end
end

-----------------------------------------------
-- Allow the platforms to be set as safe
-----------------------------------------------
function setSafeTrue()
	safe=true
end

-----------------------------------------------
-- Allow the platforms to be set as unsafe
-----------------------------------------------
function setSafeFalse()
	safe=false
end

-----------------------------------------------
-- Sets flag if in level 2
-----------------------------------------------
function setInLevel2True()
	inLevel2 = true
end

-----------------------------------------------
-- Sets flag if not in level 2
-----------------------------------------------
function setInLevel2False()
	inLevel2 = false
end

-----------------------------------------------
-- Check if the beaver fell in the water
-----------------------------------------------
function checkForSplash()
	if pcall(function()
		if (beaver.y < 420 and beaver.y > 42) and safe==false then
			print("splash")
			if (game_options.getSound() == 'on') then
				audio.play(splashSound)
			end
			wasSplashed = true
			initialPosition()
		end
	end) then
	end
end

-----------------------------------------------
-- Retrieves Beaver's X position
-----------------------------------------------
function getBeaverX()
	return beaver.x
end

-----------------------------------------------
-- Returns the value of paused
-----------------------------------------------
function getPaused()
	return paused
end

-----------------------------------------------
-- Retrieves Beaver's Y position
-----------------------------------------------
function getBeaverY()
	return beaver.y
end

-----------------------------------------------
-- Moves the beaver with a platform
-----------------------------------------------
function moveWith(event,force)
	if pcall(function()
		beaver:applyForce(-(beaver.force),0,beaver.x,beaver.y)
		beaver.force = 0
		beaver:applyForce(force,0,beaver.x,beaver.y)
		beaver.force = force
	end) then
	end
end

-----------------------------------------------
-- Stop the beaver
-----------------------------------------------
function stopForce()
	if pcall(function()
		beaver:applyForce(-(beaver.force),0,beaver.x,beaver.y)
		beaver.force = 0
	end) then
	end
end

-----------------------------------------------
-- Snaps the beaver to platform's middle
-----------------------------------------------
function snapTo(x1,y1)
	transition.to(beaver, {time=0, x=x1, y=y1})
end