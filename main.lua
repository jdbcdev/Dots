application:setKeepAwake(true)
application:setOrientation(Application.PORTRAIT)

--require("mobdebug").start()

GameScene = Core.class(Sprite)

local num_rows = 7
local num_columns = 6
						
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
	self:addEventListener(Event.MOUSE_UP, GameScene.release, self)

end

function GameScene:create()
	self.first_time = true
	self:drawDots()
	self.first_time = false
end

-- Draw the background layer
function GameScene:draw_background()
	local texture_bg = Texture.new("gfx/element.png", true, {wrap = Texture.REPEAT})

	local bg_width = application:getLogicalWidth() + 100
	local bg_height = application:getLogicalHeight() + 100
	local background = Shape.new()
	background:setFillStyle(Shape.TEXTURE, texture_bg)
	background:beginPath(Shape.NON_ZERO)
	background:moveTo(-100,-100)
	background:lineTo(bg_width, -100)
	background:lineTo(bg_width, bg_height)
	background:lineTo(-100, bg_height)
	background:lineTo(-100,-100)
	background:endPath()
	self:addChild(background)
end

-- Set up dots
function GameScene:drawDots()

	math.randomseed( os.time() )
	
	local board = self.board or {}
	
	local posX = 15
	local posY = 200
	local i,j
	for i=1, num_rows do
		board[i] = board[i] or {}
		for j=1, num_columns do	
			-- print(board[i][j])
			local dot = board[i][j] 
			if not dot then
				-- print("new dot", i, j)
				dot = Dot.new(i, j)
				board[i][j] = dot
				--dot:setPosition(posX, posY)
				
				if (not self.first_time) then
					dot:setPosition(posX, posY - 70)
					
					-- Gtween animation here to posY
					local tween = GTween.new(dot, 0.3, 
									{y = posY}, 
									{ease = easing.outBack})
				else
					dot:setPosition(posX, posY)
				end
			end
			
			self:addChild(dot)
			posX = posX + dot:getWidth() + 24
		end
		
		posX = 15
		posY = posY + 70
	end
	
	print("------------------")
	
	self.board = board
end

-- Draw score and time
function GameScene:drawHud()
	local hud = Hud.new()
	self.hud = hud
	self:addChild(hud)
end

-- Dot is released
function GameScene:release(event)
	
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
					
		local list = self.list
		if (list) then
			if (#list >= 3) then
				self.hud:updateScore(list)
				self:deleteList()
			end	
		end
	end
				
	self:deleteTrack()
end

-- Remove dots list from scene when matching happens
function GameScene:deleteList()
	local list = self.list
	local board = self.board
	
	local i
	for i=1, #list do
		local dot = list[i]
		if (dot and self:contains(dot)) then
			board[dot.row][dot.col] = nil
			self:removeChild(dot)
		end
	end
	
	-- Drop new dots from the top
	self.list = nil
	if (list and #list > 0) then
		self.gaps = #list
		self:settleDots()
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
	
	local i,j
	for j = 1, num_columns do
		for i = num_rows, 2, -1 do
			local dot = board[i][j]
			if not dot then
				local index = self:lookForDot(i-1, j) -- Looking for a dot must be dropped
				if (index == 0) then
					-- No gem to drop
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
														print("gaps es cero")
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
			-- print(i)
			local line = lines[i] -- a Shape segment
			if (line and self:contains(line)) then
				self:removeChild(line)
			end
		end
							
		self.lines = {}
	end
end


local scene = GameScene.new()
stage:addChild(scene)
