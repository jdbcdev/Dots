
Dot = Core.class(Sprite)

local colors = {
				0xFFFF00,
				0xFF0000,
				0xFFA500,
				0x228B22,
				0x0000FF
				}

textures_types = {
						Texture.new("gfx/circle_yellow.png", true),
						Texture.new("gfx/circle_red.png", true),
						Texture.new("gfx/circle_orange.png", true),
						Texture.new("gfx/circle_green.png", true),
						Texture.new("gfx/circle_blue.png", true),
						-- Texture.new("gfx/circle_grey.png", true)
						}

-- Check if two dots given are neighbords (horizontal, vertical or diagonal)
local function isNeighbord(dot1, dot2)

	if (dot1 == dot2) then
		return false
	end
	
	local result = ((dot1.row == dot2.row) and (dot1.col == dot2.col + 1 or dot1.col == dot2.col -1)) or -- same row
					((dot1.col == dot2.col) and (dot1.row == dot2.row + 1 or dot1.row == dot2.row -1)) or -- same row
					(math.abs(dot1.col - dot2.col) == 1 and math.abs(dot1.row - dot2.row) == 1) -- diagonal
	
	return result
end

-- Return line from dot1 to dot2
local function create_line(dot1, dot2)
	if not (dot1 == dot2) then
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

-- Constructor
function Dot:init(row, col)
	local color = math.random(5)
	local dot = Bitmap.new(textures_types[color])
	self.enabled = true -- ?
	self.color = color
	self.row = row
	self.col = col
	self:setScale(0.43)
	self:addChild(dot)
	
	self:addEventListener(Event.MOUSE_DOWN, self.click, self)
	self:addEventListener(Event.MOUSE_MOVE, self.move, self)
	
	--self:addEventListener(Event.MOUSE_UP, self.release, self)
end

--Dot is pressed
function Dot:click(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		
		local scene = self:getParent()
		
		local list = {} 
		list[1] = self -- first dot
		scene.current_dot = self
		scene.list = list
	end
end

-- Moving dot while screen is pressed
function Dot:move(event)
	if self:hitTestPoint(event.x, event.y) then
		local scene = self:getParent()
		event:stopPropagation()
					
		-- TODO 
		local list = scene.list
		if (list) then
			-- Check if dot is already in the list
			local current_dot = scene.current_dot
			if (current_dot.color == self.color and not (current_dot == self))
					and isNeighbord(current_dot, self) then	-- Same dot type
								
				--New dot only if dot already exists
				if not (table.contains(list, self)) then
					table.insert(list, self)
					scene.current_dot = self
									
					-- Draw one line to connect two dots
					local line = create_line(current_dot, self)
					if line then
						scene:addChild(line)
						local lines = scene.lines
						lines[#lines + 1] = line
					end
				end
			end
		end
	end
end

function Dot:setBoard(row, col)
	self.row = row
	self.col = col
end