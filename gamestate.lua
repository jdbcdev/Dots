
GameState = Core.class()

function GameState:init()

	self.highscore = 0
	self.powerups = {10, 0, 0}
	self.coins = 0
	
	self:load()
end

-- Load game progress from disk
function GameState:load()
	
	--dataSaver.saveValue("state", nil)
	
	local state = dataSaver.loadValue("state")
	if state then 
		self.powerups = state.powerups
		self.highscore = state.highscore
		self.coins = state.coins
	end
end


-- Save game progress to disk
function GameState:save()
	
	local state = { 
					highscore = self.highscore,
					powerups = self.powerups,
					coins = self.coins
					}
	dataSaver.saveValue("state", state)

end

-- User gets coins playing
function GameState:add_coins(score)
	self.coins = self.coins + score
end

-- User have used coins to get powerups
function GameState:remove_coins(num)
	local coins = self.coins - num
	if (coins < 0) then
		coins = 0
	end
	self.coins = coins or 0
end

-- Increase a powerup type in 5
function GameState:add_powerup(index)
	self.powerups[index] = self.powerups[index] + 5
end

-- Check if given score is better than previous best score
--[[
function GameState:check_score(score)

	if (score and score > self.highscore) then
		self.highscore = score
		return true
	end
	
	return false
end
]]--

-- Save new highscore
function GameState:saveHighscore(points)
	self.highscore = points
	self:save()
end