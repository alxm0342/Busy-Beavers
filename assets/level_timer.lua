-----------------------------------------------------------------------------------------
--
-- level_timer.lua
--
-----------------------------------------------------------------------------------------
module(..., package.seeall)

local twigs = require("assets.twigs")
local timeLeft = 150

-----------------------------------------------
-- Reset the timer
-----------------------------------------------
function resetTime()
	timeLeft = 150
end

-----------------------------------------------
-- Return the time left on timer
-----------------------------------------------
function getTime()
	return timeLeft
end

-----------------------------------------------
-- Set time left on timer
-----------------------------------------------
function setTime(x)
	timeLeft = x
end

-----------------------------------------------
-- Decrement the timer
-----------------------------------------------
function decrementTime()
	timeLeft = timeLeft - 1
end

-----------------------------------------------
-- Multiply the time by the score to get the total
-----------------------------------------------
function getMultipliedTime()
	if (timeLeft == 0) then
		return twigs.getScore()
	else
		return twigs.getScore()*timeLeft
	end
end