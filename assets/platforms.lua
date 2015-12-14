-----------------------------------------------------------------------------------------
--
-- platforms.lua
--
-----------------------------------------------------------------------------------------

module(..., package.seeall)
local game_options = require('assets.game_options')
local movement
local twig
local l1
local l2
local l1s
local l2s
local hippo  
local r1
local r2
local r3
local r4
local r5
local r6
local r7
local row
local crocTimers = {}
local boatTimers = {}
local sprites = {}
local hippoSprites = {}
local twigTimer
local removeLeft
local crocSound
local twigSound
local removeRight
local forceConst = .22
local rad = 10
local rShape = {-15,-5,15,-5,15,5,-15,5}
local rShape2 = { -25,-5,5,-5,5,5,-25,5}
local sheetData = { width=100, height=50, numFrames= 8}
local hippoSheetData = { width=150, height=50, numFrames= 3}
local mySheet = graphics.newImageSheet("media/spriteSheet.png", sheetData)
local myHippoSheet = graphics.newImageSheet("media/hippoSpriteSheet.png", hippoSheetData)
local crocSequenceData = {
    { name = "croc", start=1, count=2, time = 4000 ,loopCount = 0}
}
local boatSequenceData = {
    { name = "boat", start=3, count=3, time = 2900 ,loopCount = 1}
}
local hippoSequenceData = {
    { name = "hippo", start=1, count=3, time = 2900 ,loopCount = 1}
}
local purpleBoatSequenceData = {
    { name = "purple boat", start=6, count=3, time = 1900 ,loopCount = 1}
}
local hasTimer11

-------------------------------------------
-- Start the platforms for level 1
-------------------------------------------
function loadPlatforms()
	hasTimer11 = false
	r1 = 1
	r2 = 1
	r3 = 1
	r4 = 1
	r5 = 1
	r6 = 1
	r7 = 1

	print("loading platforms.lua")
	physics = require('physics')
	physics.start()
	physics.setGravity(0, 0)
	--physics.setDrawMode( "hybrid" )
	
	movement = require("assets.movement")
	twig = require('assets.twigs')
	
	l1 = require("assets.level1")
	l2 = require("assets.level2")
	l1s = require("assets.level1_saved")
	l2s = require("assets.level2_saved")
	
	crocSound = audio.loadSound("media/sounds/croc.mp3")
	twigSound = audio.loadSound("media/sounds/twig.mp3")
	
	removeLeft = display.newImage('media/tire.png', -170,206)
	removeLeft.isSensor = true
	removeLeft.name = 'removeLeft'
	removeLeft:addEventListener("collision", onRemoveCollision)
	physics.addBody(removeLeft, 'static',{shape = {-25,-190,25,-190,25,190,-25,190}})
	
	removeRight = display.newImage('media/tire.png', 480,206)
	removeRight.isSensor = true
	removeRight.name = 'removeRight'
	removeRight:addEventListener("collision", onRemoveCollision)
	physics.addBody(removeRight, 'static',{shape = {-25,-190,25,-190,25,190,-25,190}})
	
	platforms = display.newGroup()	
	platforms:insert(1, removeLeft)
	timer1 = timer.performWithDelay(1000,addPlatform_1,0)
	timer2 = timer.performWithDelay(1000,addPlatform_2,0)
	timer3 = timer.performWithDelay(1000,addPlatform_3,0)
	timer4 = timer.performWithDelay(3000,addPlatform_4,0)
	timer5 = timer.performWithDelay(1000,addPlatform_5,0)
	timer6 = timer.performWithDelay(1000,addPlatform_6,0)
	timer7 = timer.performWithDelay(1000,addPlatform_7,0)
	return platforms
end

-------------------------------------------
-- Start the platforms for level 2
-------------------------------------------
function loadPlatforms2()

	r1 = 1
	r2 = 1
	r3 = 1
	r4 = 1
	r5 = 1
	r6 = 1
	r7 = 1

	print("loading platforms.lua for level2")
	physics = require('physics')
	physics.start()
	physics.setGravity(0, 0)
	--physics.setDrawMode( "hybrid" )
	
	movement = require("assets.movement")
	twig = require('assets.twigs')
	
	l1 = require("assets.level1")
	l2 = require("assets.level2")
	l1s = require("assets.level1_saved")
	l2s = require("assets.level2_saved")
	
	batSound = audio.loadSound("media/sounds/bat.mp3")
	crocSound = audio.loadSound("media/sounds/croc.mp3")
	twigSound = audio.loadSound("media/sounds/twig.mp3")
	
	removeLeft = display.newImage('media/tire.png', -170,206)
	removeLeft.isSensor = true
	removeLeft.name = 'removeLeft'
	removeLeft:addEventListener("collision", onRemoveCollision)
	physics.addBody(removeLeft, 'static',{shape = {-25,-190,25,-190,25,190,-25,190}})
	
	removeRight = display.newImage('media/tire.png', 480,206)
	removeRight.isSensor = true
	removeRight.name = 'removeRight'
	removeRight:addEventListener("collision", onRemoveCollision)
	physics.addBody(removeRight, 'static',{shape = {-25,-190,25,-190,25,190,-25,190}})

	platforms = display.newGroup()
	platforms:insert(1, removeLeft)
	timer1 = timer.performWithDelay(1000,addPlatform_1_2,0)
	timer2 = timer.performWithDelay(1000,addPlatform_2_2,0)
	timer3 = timer.performWithDelay(1000,addPlatform_3_2,0)
	timer4 = timer.performWithDelay(3000,addPlatform_4,0)
	timer5 = timer.performWithDelay(1000,addPlatform_5_2,0)
	timer6 = timer.performWithDelay(1000,addPlatform_6_2,0)
	timer7 = timer.performWithDelay(1000,addPlatform_7_2,0)
	timer11 = timer.performWithDelay(3000,addBat,0)
	hasTimer11 = true
	return platforms
end

-------------------------------------------
-- Pause the platforms
-------------------------------------------
function pausePlatforms()
	timer.pause( timer1 )
	timer.pause( timer2 )
	timer.pause( timer3 )
	timer.pause( timer4 )
	timer.pause( timer5 )
	timer.pause( timer6 )
	timer.pause( timer7 )
	if hasTimer11 == true then
		timer.pause( timer11 )
	end
	if (twigTimer ~= nil) then
		timer.pause( twigTimer )
	end
	table.foreach(crocTimers, function(k)
		timer.pause(crocTimers[k])
		end)
	table.foreach(boatTimers, function(k)
		timer.pause(boatTimers[k])
		end)
end

-------------------------------------------
-- Resume the platforms
-------------------------------------------
function resumePlatforms()
	timer.resume( timer1 )
	timer.resume( timer2 )
	timer.resume( timer3 )
	timer.resume( timer4 )
	timer.resume( timer5 )
	timer.resume( timer6 )
	timer.resume( timer7 )
	if hasTimer11 == true then
		timer.resume( timer11 )
	end
	if (twigTimer ~= nil) then
		timer.resume( twigTimer )
	end
	table.foreach(crocTimers, function(k)
		timer.resume(crocTimers[k])
		end)
	table.foreach(boatTimers, function(k)
		timer.resume(boatTimers[k])
		end)
end

-------------------------------------------
-- Cancel all timers
-------------------------------------------
function unloadPlatforms()
	timer.cancel( timer1 )
	timer1 = nil
	timer.cancel( timer2 )
	timer2 = nil
	timer.cancel( timer3 )
	timer3 = nil
	timer.cancel( timer4 )
	timer4 = nil
	timer.cancel( timer5 )
	timer5 = nil
	timer.cancel( timer6 )
	timer6 = nil
	timer.cancel( timer7 )
	timer7 = nil
	if hasTimer11 == true then
		timer.cancel( timer11 )
		timer11 = nil
	end
	if (twigTimer ~= nil) then
		timer.cancel( twigTimer )
		twigTimer = nil
	end
	table.foreach(crocTimers, function(k)
		timer.cancel(crocTimers[k])
		crocTimers[k] = nil
		end)
	table.foreach(boatTimers, function(k)
		timer.cancel(boatTimers[k])
		boatTimers[k] = nil
		end)
	crocSound = nil
	twigSound = nil
	movement = nil
	twig = nil
end

-------------------------------------------
-- Handle the platform removals
-------------------------------------------
function onRemoveCollision(event)
	if (event.other.hasTimer == true) then
		timer.cancel(event.other.timer8)
		table.foreach(crocTimers, function(k)
			if (event.other.timer8 == crocTimers[k]) then
				table.remove(crocTimers, k)
			end
			end)
		timer.cancel(event.other.timer9)
		table.foreach(crocTimers, function(k)
			if (event.other.timer9 == crocTimers[k]) then
				table.remove(crocTimers, k)
			end
			end)
--		timer.cancel(event.other.timer10)
		table.foreach(crocTimers, function(k)
			if (event.other.timer10 == crocTimers[k]) then
				table.remove(crocTimers, k)
			end
			end)
	end
		table.remove(sprites,1)
	display.remove(event.other)
	event.other = nil
end

-------------------------------------------
-- Handle the platform and twig collisions
-------------------------------------------
function onCollision(event)
	local timer11
	local timer12
	if (event.other.name == 'boat') then
		if(event.phase == 'began') then
			movement.setSafeTrue()
			movement.snapTo(event.other.x-10,event.other.y)
			movement.moveWith(event,event.other.force)
			print('Boat is sinking!!!')
			event.other:play()
			timer11 = timer.performWithDelay(2000, 
				function()
					if(event.other.isVisible == true) then 
						movement.setSafeFalse()
						if (event.other.x < (movement.getBeaverX() + 17)) and (event.other.x > (movement.getBeaverX() - 3)) then
							if (event.other.y < (movement.getBeaverY() + 7)) and (event.other.y > (movement.getBeaverY() - 17)) then
								movement.checkForSplash()
							end
						end
						display.remove(event.other)
						event.other = nil
					end
				end,1)
			table.insert(boatTimers, timer11)
		end
	elseif (event.other.name == 'purple boat') then
		if(event.phase == 'began') then
			movement.setSafeTrue()
			movement.snapTo(event.other.x-10,event.other.y)
			movement.moveWith(event,event.other.force)
			print('Purple Boat is sinking!!!')
			event.other:play()
			timer11 = timer.performWithDelay(1000, 
				function()
		print(event.other.x)
		print(movement.getBeaverX())
		print(event.other.y)
		print(movement.getBeaverY())
					if(event.other.isVisible == true) then 
						movement.setSafeFalse()
						if (event.other.x < (movement.getBeaverX() + 20)) and (event.other.x > (movement.getBeaverX() - 6)) then
							if (event.other.y < (movement.getBeaverY() + 10)) and (event.other.y > (movement.getBeaverY() - 10)) then
								movement.checkForSplash()
							end
						end
						display.remove(event.other)
						event.other = nil
					end
				end,1)
			table.insert(boatTimers, timer11)
		end
	elseif (event.other.name == 'tire') then
		if(event.phase == 'began') then
			movement.setSafeTrue()
			movement.snapTo(event.other.x,event.other.y)
			movement.moveWith(event,event.other.force)
			print("tire collision!")
		end
	elseif (event.other.name == 'croc') then
		if(event.phase == 'began') then
			movement.setSafeTrue()
			print("croc collision!")
			movement.snapTo(event.other.x,event.other.y)
			movement.setSafeTrue()
			movement.moveWith(event,event.other.force)
		end
	elseif (event.other.name == 'lilypad') then
		if(event.phase == 'began') then
			print("lilypad collision!")
			movement.setSafeTrue()
			movement.snapTo(event.other.x,event.other.y)
			movement.setSafeTrue()
			movement.moveWith(event,event.other.force)
		end
	elseif (event.other.name == 'twig') then
		if(event.phase == 'began') then
			timer.performWithDelay(200, function()
				if pcall(function()
					local twigX = event.other.twigId
					print('twig collected!')
					print(event.other.twigId)
					if (game_options.getSound() == 'on') then
						audio.play(twigSound)
					end
					if (event.other ~= nil) then
						event.other:removeSelf()
						event.other = nil
					end
					twig.updateScore()
					movement.initialPosition()
					twigTimer = timer.performWithDelay(1000, function()
						twig.addTwig(twigX, 0)
						twigX = nil
					end, 1)
				end) then
				end
			end, 1)
		end
	elseif(event.other.name == 'red croc') then
		movement.setSafeTrue()
		timer.performWithDelay(100, function()
			if pcall(function()
				movement.initialPosition()
				if (game_options.getSound() == 'on') then
					audio.play(crocSound)
				end
				end) then
			end
		end, 1)
	elseif(event.other.name == "bat") then
		movement.setSafeTrue()
		timer.performWithDelay(100, function()
			if pcall(function() 
				movement.initialPosition()
				if (game_options.getSound() == 'on') then
					audio.play(batSound)
				end
				end) then
			end
		end, 1)
	else
		if(event.phase == 'began') then
			movement.setSafeTrue()
			movement.stopForce()
			print("hippo collision!")
		end
	end
end

-------------------------------------------
-- Create platform for row 1, level 1
-------------------------------------------
function addPlatform_1()
	local t
	if r1 > 0 then
		t = display.newSprite(mySheet,crocSequenceData)
		table.insert(sprites,t)
		t.y = 70	
		t.x = -50
		t:play()
		t.hostile = 0
		t.hasTimer = true
		r1 = r1*(-1)
		t.force = forceConst*1.1
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
		t.timer9 = timer.performWithDelay(2000, 
			function()
				t.hostile = 1
				t.timer10 = timer.performWithDelay(2000, 
					function()
					t.hostile = 0
					end,1)
				table.insert(crocTimers, t.timer10)
				end,0)
		table.insert(crocTimers, t.timer9)
		t.name = 'croc'
		t.timer8 = timer.performWithDelay(100, function()
				if(t.hostile == 1) then
					if ((t.x < (movement.getBeaverX() + 33)) and (t.x > (movement.getBeaverX() -12))) and ((t.y < (movement.getBeaverY() + 8)) and (t.y > (movement.getBeaverY() - 8))) then
						if (game_options.getSound() == 'on') then
							audio.play(crocSound)
						end
						movement.initialPosition()
					end
				end end,0)
		table.insert(crocTimers, t.timer8)
	else
		t = display.newImage('media/lilypad.png', -100,43.73)
		t.hasTimer = false
		t.isSprite = false
		t.name = 'lilypad'
		r1 = r1*(-1)
		t.force = forceConst*1.1
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	end

end

-------------------------------------------
-- Create platform for row 1, level 2
-------------------------------------------
function addPlatform_1_2()
	local t
	if r1 > 0 then
		t = display.newImage('media/lilypad.png', -100,43.73)
		t.name = 'lilypad'
	else
		t = display.newImage('media/croc_lvl2.png',-115,48.73)
		t.name = 'red croc'
	end
	t.hasTimer = false
	r1 = r1*(-1)
	t.force = forceConst*1.1
	physics.addBody(t, 'dynamic',{shape = rShape})
	t.isSensor = true
	platforms:insert(1, t)
	t:applyForce(t.force,0,t.x,t.y)
end

-------------------------------------------
-- Create platform for row 2, level 1
-------------------------------------------
function addPlatform_2()
	local t
	if r2 > 0 then
		t = display.newSprite(mySheet,boatSequenceData)
		t.x = 470
		t.y = 130
		t.name = 'boat'
		t.hasTimer = false
		r2 = r2*(-1)
		t.force = -forceConst
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	else 
		t = display.newImage('media/tire.png',415,111.86)
		t.name = 'tire'
		t.hasTimer = false
		r2 = r2*(-1)
		t.force = -forceConst
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	end
end

-------------------------------------------
-- Create platform for row 2, level 2
-------------------------------------------
function addPlatform_2_2()
	local t
	if r2 > 0 then
		t = display.newSprite(mySheet, purpleBoatSequenceData) 
		t.x = 470
		t.y = 130
		t.name = 'purple boat'
		t.hasTimer = false
		r2 = r2*(-1)
		t.force = -forceConst
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	else 
		t = display.newImage('media/tire.png',415,111.86)
		t.name = 'tire'
		t.hasTimer = false
		r2 = r2*(-1)
		t.force = -forceConst
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	end
end

-------------------------------------------
-- Create platform for row 3, level 1
-------------------------------------------
function addPlatform_3()
	local t
	if r3 > 0 then
		t = display.newImage('media/lilypad.png', -100,150.93)
		t.hasTimer = false
		t.name = 'lilypad'
		r3 = r3*(-1)
		t.force = forceConst*1.1
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	else
		t = display.newSprite(mySheet,crocSequenceData)
		table.insert(sprites,t)
		t.y = 185
		t.x = -50
		t:play()
		t.hostile = 0
		t.hasTimer = true
		r3 = r3*(-1)
		t.force = forceConst*1.1
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
		t.timer9 = timer.performWithDelay(2000, 
			function()
				t.hostile = 1
				t.timer10 = timer.performWithDelay(2000, 
					function()
					t.hostile = 0
					end,1) 
				table.insert(crocTimers, t.timer10)
				end,0)
		table.insert(crocTimers, t.timer9)
		t.name = 'croc'
		t.timer8 = timer.performWithDelay(100, function()
				if(t.hostile == 1) then
					if ((t.x < (movement.getBeaverX() + 33)) and (t.x > (movement.getBeaverX() -12))) and ((t.y < (movement.getBeaverY() + 8)) and (t.y > (movement.getBeaverY() -8))) then
						if (game_options.getSound() == 'on') then
							audio.play(crocSound)
						end
						movement.initialPosition()
					end
				end end,0)
		table.insert(crocTimers, t.timer8)
	end
end


-------------------------------------------
-- Create platform for row 3, level 2
-------------------------------------------
function addPlatform_3_2()
	local t
	if r3 > 0 then
		t = display.newImage('media/croc_lvl2.png',-115,155.94)
		t.name = 'red croc'
	else
		t = display.newImage('media/lilypad.png', -100,150.93)
		t.name = 'lilypad'
	end
	t.hasTimer = false
	r3 = r3*(-1)
	t.force = forceConst*1.1
	physics.addBody(t, 'dynamic',{shape = rShape})
	t.isSensor = true
	platforms:insert(1, t)
	t:applyForce(t.force,0,t.x,t.y)
end

-------------------------------------------
-- Create platform for row 4
-------------------------------------------
function addPlatform_4()
	local movement = require("assets.movement")
	if r4 > 0 then
		--75,220
		hippo = display.newSprite(myHippoSheet,hippoSequenceData)
		table.insert(hippoSprites,hippo)
		hippo.x = 160
		hippo.y = 240
		hippo:play()
		hippo.name = 'hippo'
		hippoShape = { -40,-15, 60,-15, 60,15, -40,15}
		physics.addBody(hippo, 'dynamic', {shape=hippoShape})
		hippo.isSensor = true
		platforms:insert(1, hippo)
	else 
		display.remove(hippo)
		hippo = nil
		table.remove(hippoSprites)
		if movement.getBeaverX() > 80 and movement.getBeaverX() < 225 and movement.getBeaverY() < 260 and movement.getBeaverY() > 220 then
			movement.setSafeFalse()
			movement.checkForSplash()
		end
	end
	r4 = r4*(-1)
end

-------------------------------------------
-- Create platform for row 5, level 1
-------------------------------------------
function addPlatform_5()
	local t
	if r5 > 0 then
		t = display.newImage('media/tire.png', 415,274.19) 
		t.name = 'tire'
		t.hasTimer = false
		r5 = r5*(-1)
		t.force = -forceConst
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	else 
		t = display.newSprite(mySheet,boatSequenceData)
		t.x = 470
		t.y = 290
		t.name = 'boat'
		t.hasTimer = false
		r5 = r5*(-1)
		t.force = -forceConst
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	end

end

-------------------------------------------
-- Create platform for row 5, level 2
-------------------------------------------
function addPlatform_5_2()
	local t
	if r5 > 0 then
		t = display.newImage('media/tire.png', 415,274.19) 
		t.name = 'tire'
		t.hasTimer = false
		r5 = r5*(-1)
		t.force = -forceConst
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	else 
		t = display.newSprite(mySheet, purpleBoatSequenceData)
		t.x = 470
		t.y = 290
		t.name = 'purple boat'
		t.hasTimer = false
		r5 = r5*(-1)
		t.force = -forceConst
		t.hostile = 0
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	end
end

-------------------------------------------
-- Create platform for row 6, level 1
-------------------------------------------
function addPlatform_6()
	local t
	if r6 > 0 then
		t = display.newSprite(mySheet,crocSequenceData)
		table.insert(sprites,t)
		t.y = 340
		t.x = -50
		t:play()
		t.hostile = 0
		t.hasTimer = true
		r6 = r6*(-1)
		t.force = forceConst*1.1
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
		t.timer9 = timer.performWithDelay(2000, 
			function()
				t.hostile = 1
				t.timer10 = timer.performWithDelay(2000, 
					function()
					t.hostile = 0
					end,1) 
				table.insert(crocTimers, t.timer10)
				end,0)
		table.insert(crocTimers, t.timer9)
		t.name = 'croc'
		t.timer8 = timer.performWithDelay(100, function()
				if(t.hostile == 1) then
					if ((t.x < (movement.getBeaverX() + 33)) and (t.x > (movement.getBeaverX() -12))) and ((t.y < (movement.getBeaverY() + 8)) and (t.y > (movement.getBeaverY() -8))) then
						if (game_options.getSound() == 'on') then
							audio.play(crocSound)
						end
						movement.initialPosition()
					end
				end end,0)
		table.insert(crocTimers, t.timer8)
	else 
		t = display.newImage('media/lilypad.png',-100,310.93)
		t.hasTimer = false
		t.name = 'lilypad'
		r6 = r6*(-1)
		t.force = forceConst*1.1
		
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)
	end
end

-------------------------------------------
-- Create platform for row 6, level 2
-------------------------------------------
function addPlatform_6_2()
	local t
	if r6 > 0 then
		t = display.newImage('media/lilypad.png', -100,310.93)
		t.name = 'lilypad'
	else
		t = display.newImage('media/croc_lvl2.png',-115,315.93)
		t.name = 'red croc'
	end
	t.hasTimer = false
	r6 = r6*(-1)
	t.force = forceConst*1.1
	physics.addBody(t, 'dynamic',{shape = rShape})
	t.isSensor = true
	platforms:insert(1, t)
	t:applyForce(t.force,0,t.x,t.y)
end

-------------------------------------------
-- Create platform for row 7, level 1
-------------------------------------------
function addPlatform_7()
	local t
	if r7 > 0 then
		t = display.newSprite(mySheet,boatSequenceData)
		t.x = 470
		t.y = 395
		t.name = 'boat'
		t.hasTimer = false
		r7 = r7*(-1)
		t.force = -forceConst
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)	
	else 
		t = display.newImage('media/tire.png', 415, 377.73) 
		t.name = 'tire'
		t.hasTimer = false
		r7 = r7*(-1)
		t.force = -forceConst
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)	
	end
end

-------------------------------------------
-- Create platform for row 7, level 2
-------------------------------------------
function addPlatform_7_2()
	local t
	if r7 > 0 then
		t = display.newSprite(mySheet, purpleBoatSequenceData)
		t.x =470
		t.y = 395
		t.name = 'purple boat'
		t.hasTimer = false
		r7 = r7*(-1)
		t.force = -forceConst
		physics.addBody(t, 'dynamic',{shape = rShape2})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)	
	else 
		t = display.newImage('media/tire.png', 415, 377.73) 
		t.name = 'tire'
		r7 = r7*(-1)
		t.force = -forceConst
		physics.addBody(t, 'dynamic',{shape = rShape})
		t.isSensor = true
		platforms:insert(1, t)
		t:applyForce(t.force,0,t.x,t.y)	
	end
end

-------------------------------------------
-- Add bat for level 2
------------------------------------------
function addBat()
	local bat
	row = math.random(1,7)
	if row == 7 then
		bat = display.newImage("media/bat.png",420,365.93)
	elseif row == 6 then
		bat = display.newImage("media/bat.png",420,310.93)
	elseif row == 5 then
		bat = display.newImage("media/bat.png",420,260.93)
	elseif row == 4 then
		bat = display.newImage("media/bat.png",420,210)
	elseif row == 3 then
		bat = display.newImage("media/bat.png",420,150.93)
	elseif row == 2 then
		bat = display.newImage("media/bat.png",420,95.86)
	else
		bat = display.newImage("media/bat.png",420,40.93)
	end
	bat.name = "bat"
	bat.hasTimer = false
	bat.force = -forceConst/.5
	physics.addBody(bat, 'dynamic',{shape = rShape})
	bat.isSensor = true
	platforms:insert(99, bat)
	bat:applyForce(bat.force,0,bat.x,bat.y)	
end
