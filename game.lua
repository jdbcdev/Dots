GameScene = Core.class(Sprite)

local num_rows = 7
local num_columns = 6

local font = TTFont.new("fonts/new_academy.ttf", 40)

function table.contains(list, element)
  for _, value in pairs(list) do
    if value == element then
      return true
    end
  end
  return false
end

-- Constructor
function GameScene:init()
		
	self:create()
	self:drawHud()
	
	self.lines = {}
	
	--Event listeners
	self:addEventListener(Event.MOUSE_UP, self.release, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	
	Advertise.hideBanner()
end

-- Create dots on screen for the first time
function GameScene:create()
	self.first_time = true
	
	self.enable_remove = false -- Enabling to remove a single dot with double tap
	
	-- Create a dots layer
	local layer = Sprite.new()
	self:addChild(layer)
	self.layer_dots = layer
	
	self:drawDots()
	self.first_time = false
end

-- Set up dots
function GameScene:drawDots()

	math.randomseed( os.time() )
	
	local layer = self.layer_dots
	local board = self.board or {}
	
	local posX = 65
	local posY = 130

	for i=1, num_rows do
		board[i] = board[i] or {}
		for j=1, num_columns do	
			-- print(board[i][j])
			local dot = board[i][j] 
			if not dot then
				-- print("new dot", i, j)
				dot = Dot.new(i, j)
				board[i][j] = dot
				
				if (not self.first_time) then
					dot:setPosition(posX, posY - 70)
					
					-- Gtween animation here to posY
					local tween = GTween.new(dot, 0.5, 
									{y = posY}, 
									{ease = easing.outBack})
				else
					dot:setPosition(posX, posY)
				end
			end
			
			layer:addChild(dot)
			posX = posX + dot:getWidth() + 24
		end
		
		posX = 65
		posY = posY + 70
	end
	
	self.board = board
end

-- Draw score and time
function GameScene:drawHud()
	local hud = Hud.new(self)
	self.hud = hud
end

-- Dot is released
function GameScene:release(event)
	
	if (self:hitTestPoint(event.x, event.y)) then
		event:stopPropagation()
					
		local list = self.list
		if (list) then
			local hud = self.hud
						
			if (#list >= 2) then
				
				hud:updateScore(list)
				self:deleteDots()
				hud:updateMoves()
			end	
			
			-- Previous state of current_dot
			if (#list == 1) then
				self.current_dot:setNormal()
			end
			
			-- Checking for loop
			local lines = self.lines
			if (#list > 3 and #list == #lines) then
				-- Loop (one extra move)
				--print("loop")
				hud:addMoves(1)
				
				self:showMessage("Extra move", 100, 70)
			end
		end
		
		--print(#list, #self.lines)
		
	--else
		--print("out of scene")
		
	end

	self:deleteTrack()
end

-- Remove dots list from scene when matching happens
function GameScene:deleteDots()
	
	local list = self.list
	local board = self.board
	local layer = self.layer_dots
	if (layer) then
		for i=1, #list do
			local dot = list[i]
			if (dot and self:contains(dot)) then
				board[dot.row][dot.col] = nil
				layer:removeChild(dot)
			end
		end
			
		SoundManager.play_melody(#list)

		-- Drop new dots from the top
		self.list = nil
		if (list and #list > 0) then
			self.gaps = #list
			self:settleDots()
		end
	end
end

-- Return row where dot to drop is found
function GameScene:lookForDot(row, col)
	local board = self.board
	local i = row
	while (i > 0) do
		local dot = board[i][col]
		if (dot) then
			found = true
			break
		else
			i = i - 1
		end
	end
	
	return i
end

-- Drop new dots
function GameScene:settleDots()
	local board = self.board
	local gaps = self.gaps
	local drops = 0
	
	for j = 1, num_columns do
		for i = num_rows, 2, -1 do
			local dot = board[i][j]
			if not dot then
				local index = self:lookForDot(i-1, j) -- Looking for a dot must be dropped
				if (index == 0) then
					-- No dot to drop
					break
				else
					drops = drops + 1
					local droppedDot = board[index][j]
					droppedDot.row = i
					droppedDot.col = j
					board[index][j] = nil
					board[i][j] = droppedDot
					
					-- Drop the dot
					local squareSize = 70
					local posY = droppedDot:getY() + squareSize * (i-index)
					
					local tween = GTween.new(droppedDot, 0.1 * (i-index), 
									{y = posY}, 
									{ease = easing.outBack,
									 onComplete = function()
													gaps = gaps - 1
													if (drops == 0) then
														self:drawDots()
													end
												  end
									})
				end
			end
		end
	end
	
	if (gaps > 0) then
		self:drawDots()
	end
end

-- Delete join track from memory and scene
function GameScene:deleteTrack()
	local lines = self.lines
	if (lines) then
		
		for i=1, #lines do
			local layer = self.layer_dots
			local line = lines[i] -- a Shape segment
			
			if (line and layer:contains(line)) then
				layer:removeChild(line)
			end
		end
	end
	
	self.lines = {}
end

-- Apply powerup feature depending on given index
function GameScene:apply_powerup(index)	
	print("index", index)
		
	if (index == 1) then -- Extra movements
		self.hud:addMoves()
		
		SoundManager.play_effect(8)
		self:showMessage(getString("desc1"), 30, 70)
		
		return
	end
	
	if (index == 2) then -- You can remove one dot
		SoundManager.play_effect(9)
		
		local board = self.board
		for i=1,num_rows do
			for j=1,num_columns do
				local dot = board[i][j]
				dot:addSquare()
			end
		end	
		
		self.enable_remove = true
		self:disablePowerups()
		
		self:showMessage(getString("desc2"), 30, 70)
		
		return
	end
	
	if (index == 3) then -- Diagonals are allowed
		SoundManager.play_effect(10)
				
		local board = self.board
		for i=1,num_rows do
			for j=1,num_columns do
				local dot = board[i][j]
				dot:addCircle(23)
			end
		end	
		
		self:showMessage(getString("desc3"), 30, 70)
	end
	
end

-- Back to normal state
function GameScene:removeSingleDot(dot)
	if (dot) then
		
		local board = self.board
		local layer = self.layer_dots
				
		-- Back to normal square
		if (layer and board) then
			for i=1,num_rows do
				for j=1,num_columns do
					local dot = board[i][j]
					dot:removeSquare()
				end
			end	
		end
		
		-- Remove single dot
		board[dot.row][dot.col] = nil
		layer:removeChild(dot)
		
		self.enable_remove = false
		SoundManager.play_effect(1)
		
		self:enablePowerups(2)
		
		self.gaps = 1 -- Only one dot removed
		self:settleDots()
	end
end

-- Show paused caption
function GameScene:show_paused()
	
	--self:show_layers()
	
	self.paused = true
	
	Timer.pauseAll()
	
	local button_pause = self.hud.pause
	if (button_pause) then
		button_pause:setVisible(false)
	end
	
	local caption = self.caption
	if (caption) then
		self:addChild(caption)
	else
		caption = Caption.new(self)
		self:addChild(caption)
		self.caption = caption
	end

	caption:show_ads()
end

-- Hide paused caption
function GameScene:hide_paused()
	
	self.paused = false
	Timer.resumeAll()
	
	local caption = self.caption
	if (caption and self:contains(caption)) then
		self:removeChild(caption)
	end
		
	Advertise.hideBanner()
	
	local button_pause = self.hud.pause
	if (button_pause) then
		button_pause:setVisible(true)
	end
end

-- Show all layers: hud, score and dots
function GameScene:show_layers()
	self.panel:setVisible(true)
	self.hud:setVisible(true)
	self.layer_dots:setVisible(true)
end

-- Hide hud, score and dots
function GameScene:hide_layers()
	self.panel:setVisible(false)
	self.hud:setVisible(false)
	self.layer_dots:setVisible(false)
end

-- Show bonus (x2, x3)
function GameScene:showBonus(bonus, posX, posY)

	local message = TextField.new(font,"x"..bonus)
	message:setTextColor(0xffff00)
	message:setShadow(2,1, 0x000000)
	message:setPosition(posX, posY)
	self:addChild(message)
	
	local tween = GTween.new(message, 1.2, 
							{scaleX = 1.2, scaleY = 1.2, alpha=0.5, y = posY -20},
							{ease = easing.linear, 
							onComplete = function()
											self:removeChild(message)
										end
							})
end

-- Show simple text message
function GameScene:showMessage(label, posX, posY)

	local message = TextField.new(font, label)
	message:setTextColor(0xff0000)
	message:setShadow(2,1, 0x000000)
	message:setPosition(posX, posY)
	self:addChild(message)
	
	local tween = GTween.new(message, 1.2, 
							{scaleX = 0.5, scaleY = 0.5, alpha=0.5},
							{ease = easing.linear, 
							onComplete = function()
											self:removeChild(message)
										end
							})
end

-- Disable all powerups
function GameScene:disablePowerups()

	local hud = self.hud
	
	for a=1,#hud.powerup_enabled do
		hud.powerup_enabled[a] = false
	end
end

-- Enable all powerups except given index
function GameScene:enablePowerups(index)
	local hud = self.hud
	
	for a=1,#hud.powerup_enabled do
		if (index and index == a) then
			hud.powerup_enabled[a] = false
		else
			hud.powerup_enabled[a] = not hud.powerup_used[a]
		end
	end
end


-- Back to menu when back button is pressed
function GameScene:onKeyDown(event)
	
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		
		if (self.paused) then
			event:stopPropagation()
			
			if (self.shop) then -- Powerup scene shown
				PowerupScene.hide_powerup(self)
				self:show_paused()		
			else
				sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
			end
		else
			self:show_paused()
		end
	end
end