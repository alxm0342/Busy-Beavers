-----------------------------------------------------------------------------------------
--
-- twigs.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)
local points = 0
local l1Points = 0
local p1Points = 0
local p2Points = 0
physics = require('physics')
physics.start()
physics.setGravity(0, 0)
local twigs
local PVPon
local collected = 0
local t1 = 10
local t2 = 95
local t3 = 180
local t4 = 265

-----------------------------------------------
-- Load twigs on screen
-----------------------------------------------
function loadTwigs(isPVP)
	twigs = display.newGroup()
	addTwig(1)
	addTwig(2)
	addTwig(3)
	addTwig(4)
	collected = 0
	PVPon = isPVP
	return twigs
end

-----------------------------------------------
-- Unload twigs from screen
-----------------------------------------------
function unloadTwigs()
	display.remove(twigs)
	twigs = nil
end

-----------------------------------------------
-- Create twigs
-----------------------------------------------
function addTwig(id)
	if collected < 5 or PVPon then
		local t
		t = display.newImage('media/Twig.png',getX(id),0)
		t.name = 'twig'
		t.twigId = id
		t.onBeaver = 0
		physics.addBody(t,'static')
		twigs:insert(t)
	end
end

-----------------------------------------------
-- Get the twig number
-----------------------------------------------
function getX(id)
	local x
	if id == 1 then
		x = t1
	elseif id == 2  then
		x = t2
	elseif id == 3 then
		x = t3
	else
		x = t4
	end
	return x
end

-----------------------------------------------
-- Updates the score
-----------------------------------------------
function updateScore()
	points = points + 1000
	collect()
end

-----------------------------------------------
-- Reset the score
-----------------------------------------------
function resetScore()
	points = 0
	resetCollected()
end

-----------------------------------------------
-- Reset level 1 score
-----------------------------------------------
function resetL1Score()
	l1Points = 0
end

-----------------------------------------------
-- Reset p1 score
-----------------------------------------------
function resetP1Score()
	p1Points = 0
end

-----------------------------------------------
-- Reset p2 score
-----------------------------------------------
function resetP2Score()
	p2Points = 0
end

-----------------------------------------------
-- Save level 1 score
-----------------------------------------------
function setL1Score(score)
	l1Points = score
end

-----------------------------------------------
-- Save p1 score
-----------------------------------------------
function saveP1Score()
	p1Points = points
end

-----------------------------------------------
-- Save p2 score
-----------------------------------------------
function saveP2Score()
	p2Points = points
end

-----------------------------------------------
-- Returns the score
-----------------------------------------------
function getScore()
	return points
end

-----------------------------------------------
-- Sets the score
-----------------------------------------------
function setScore(x)
	points = x
end

-----------------------------------------------
-- Returns level 1 score
-----------------------------------------------
function getL1Score()
	return l1Points
end

-----------------------------------------------
-- Returns p1 score
-----------------------------------------------
function getP1Score()
	return p1Points
end

-----------------------------------------------
-- Returns p2 score
-----------------------------------------------
function getP2Score()
	return p2Points
end

-----------------------------------------------
-- Resets the amount collected
-----------------------------------------------
function resetCollected()
	collected = 0
end

-----------------------------------------------
-- Gets the amount collected
-----------------------------------------------
function getCollected()
	return collected
end

-----------------------------------------------
-- Increments the amount collected
-----------------------------------------------
function collect()
	collected = collected+1
end