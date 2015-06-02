
Dot = Core.class(Sprite)

Dot.SQUARE = 1
Dot.CIRCLE = 2

local colors = {
				0x483D8B,
				0xFF0000,
				0xFFA500,
				0x228B22,
				0x007FFF
				}

--[[
local textures_types = {
						Texture.new("gfx/circle_yellow.png", true),
						Texture.new("gfx/circle_red.png", true),
						Texture.new("gfx/circle_orange.png", true),
						Texture.new("gfx/circle_green.png", true),
						Texture.new("gfx/circle_blue.png", true),
						-- Texture.new("gfx/circle_grey.png", true)
						}
]]--

-- Check if two dots given are neighbords (horizontal, vertical or diagonal)
local function isNeighbord(dot1, dot2, diagonal)

	if (dot1 == dot2) then
		return false
	end
	
	local result = ((dot1.row == dot2.row) and (dot1.col == dot2.col + 1 or dot1.col == dot2.col -1))  -- same row
					or ((dot1.col == dot2.col) and (dot1.row == dot2.row + 1 or dot1.row == dot2.row -1)) -- same row
					
	if diagonal then
		result = result or (math.abs(dot1.col - dot2.col) == 1 and math.abs(dot1.row - dot2.row) == 1) -- diagonal
	end
	
	return result
end

-- Return line from dot1 to dot2
local function create_line(dot1, dot2)
	if (dot1 and dot2 and (not (dot1 == dot2))) then
		local color = colors[dot1.color]
		local line = Shape.new()
		line:setLineStyle(8, color, 1)
		line:beginPath()
		line:moveTo(dot1:getX() + dot1:getWidth() * 0.5, dot1:getY() + dot1:getHeight() * 0.5)
		line:lineTo(dot2:getX() + dot2:getWidth() * 0.5, dot2:getY() + dot2:getHeight() * 0.5)
		line:endPath()
		line:closePath()
		
		return line
	end
end

-- Return a circle shape
local function create_circle(color, size)
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, color)
	shape:drawCircle(size, size, size)
	
	return shape
end

-- Return a square shape
local function create_square(color, size)
	
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, color)
	shape:drawRoundRectangle(size, size, 0)
	
	return shape
end

-- Constructor
function Dot:init(row, col)
	local color = math.random(#colors)
	
	self.type = Dot.SQUARE
		
	local square = create_square(colors[color], 50)
	
	self.enabled = true
	self.color = color
	self.row = row
	self.col = col
	
	self.square = square
	self:addChild(square)
		
	self:addEventListener(Event.MOUSE_DOWN, self.click, self)
	self:addEventListener(Event.MOUSE_MOVE, self.move, self)
end

--Dot is pressed
function Dot:click(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		
		local layer = self:getParent()
		if (layer) then
			local scene = layer:getParent()
			
			if (scene) then
			
				if (scene.enable_remove and self.type == Dot.SQUARE) then 
					-- Remove dot 
	
					scene:removeSingleDot(self)
					return
				end
				
				local list = {} 
				list[1] = self -- first dot
				scene.current_dot = self
				scene.list = list
			end
		end
	end
end

-- Moving dot while screen is pressed
function Dot:move(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		local layer = self:getParent()
		if (layer) then
			local scene = layer:getParent()
			
			if (scene and scene.list) then	
				local list = scene.list

				-- Check if dot is already in the list
				local current_dot = scene.current_dot
				local diagonal_allowed = self.diagonal_allowed or current_dot.diagonal_allowed -- Circle to square or viceversa
				if (current_dot.color == self.color and not (current_dot == self))
						and isNeighbord(current_dot, self, diagonal_allowed) then	-- Same dot color
									
					--New dot only if dot already exists
					if (self == list[1]) then
						self:draw_line()
					elseif (not table.contains(list, self)) then
							
						table.insert(list, self)
						
						-- Draw one line to connect two dots
						self:draw_line()
						scene.current_dot = self
					end
				else
					-- Remove dot list and lines
					if (not (current_dot == self)) and (not (current_dot.color == self.color) or (not isNeighbord(current_dot, self, diagonal_allowed))) then
						scene.list = {}
						scene:deleteTrack()
					end
				end
			end
		end
	end
end

-- Draw line between current_dot and self
function Dot:draw_line()
	local layer = self:getParent()
	if (layer) then
		local scene = layer:getParent()
		if (scene) then
			local current_dot = scene.current_dot
			local lines = scene.lines
			local dots = scene.list
			
			-- Avoid repeated lines
			if (#lines + 1 <= #dots) then 
				local line = create_line(current_dot, self)
				if line then
					layer:addChild(line)				
					table.insert(lines, line)
				end
			end
		end
	end
end

-- Second square enabling to remove one square dot
function Dot:addSquare()
	
	if (self.type == Dot.SQUARE) then
		local square = self.square
		square:setAlpha(0.5)
	
		local square2 = create_square(colors[self.color], 35)
		local posX = (square:getWidth() - square2:getWidth()) * 0.5
		local posY = (square:getHeight() - square2:getHeight()) * 0.5
		square2:setPosition(posX, posY)
		self:addChild(square2)
		self.square2 = square2
	end
end

function Dot:addCircle()
	
	self.type = Dot.CIRCLE
	
	local square = self.square
	square:setAlpha(0.5)
	
	local circle = create_circle(colors[self.color], 25)
	local posX = (square:getWidth() - circle:getWidth()) * 0.5
	local posY = (square:getHeight() - circle:getHeight()) * 0.5
	circle:setPosition(posX, posY)
	self:addChild(circle)
	
	self.diagonal_allowed = true
end

-- Square and normal dot
function Dot:removeSquare()
	
	if (self.type == Dot.SQUARE and self.square2) then
		self:removeChild(self.square2)
		self.square2 = nil
	
		self.square:setAlpha(1)
	end
end

-- Set row and column
function Dot:setBoard(row, col)
	self.row = row
	self.col = col
end