
GameState = Core.class()

-- Constructor
function GameState:init()

	self.highscore = 0
	self.powerups = {5, 5, 5}
	--self.powerups = {0, 0, 0}
	self.dots = 7000
	
	self:load()
end

-- Load game progress from disk
function GameState:load()
	
	--dataSaver.saveValue("state", nil)
	
	local state = dataSaver.loadValue("state")
	if state then 
		self.powerups = state.powerups
		self.highscore = state.highscore
		self.dots = state.dots
	end
	
	print("dots", self.dots)
end


-- Save game progress to disk
function GameState:save()
	
	local state = { 
					highscore = self.highscore,
					powerups = self.powerups,
					dots = self.dots
					}
	dataSaver.saveValue("state", state)

end

-- User gets dots playing
function GameState:add_dots(score)
	self.dots = self.dots + score
end

-- User have just used dots to get powerups
function GameState:remove_dots(num)
	local dots = self.dots - num
	if (dots < 0) then
		dots = 0
	end
	self.dots = dots or 0
end

-- Increase a powerup type in 5
function GameState:add_powerup(index)
	self.powerups[index] = self.powerups[index] + 5
end

-- Save new highscore
function GameState:saveHighscore(points)
	self.highscore = points
	self:save()
	
	-- Submit to facebook
	if (social) then
		social:sendScore(points)
	end
end