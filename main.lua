
--require("mobdebug").start()

GameScene = Core.class(Sprite)

local num_rows = 6
local num_columns = 6

local colors = {
				0xFFFF00,
				0xFF0000,
				0xFFA500,
				0x228B22,
				0x0000FF
				}

local textures_types = {
						--[[Texture.new("gfx/1_gems.png"),
						Texture.new("gfx/2_gems.png"),
						Texture.new("gfx/3_gems.png"),
						Texture.new("gfx/4_gems.png"),
						Texture.new("gfx/7_gems.png")
						]]--
						
						Texture.new("gfx/circle_yellow.png", true),
						Texture.new("gfx/circle_red.png", true),
						Texture.new("gfx/circle_orange.png", true),
						Texture.new("gfx/circle_green.png", true),
						Texture.new("gfx/circle_blue.png", true),
						Texture.new("gfx/circle_grey.png", true)
						}
						
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- Constructor
function GameScene:init()
	--self:draw_background()
	self:draw_dots()
	self:draw_hud()
	
	self.lines = {}
	
	--Event listeners
	self:addEventListener(Event.MOUSE_UP, GameScene.release, self)
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

-- Check if two dots given are neighbords
local function isNeighbord(dot1, dot2)

	if (dot1 == dot2) then
		return false
	end
	
	local result = ((dot1.row == dot2.row) and (dot1.col == dot2.col + 1 or dot1.col == dot2.col -1)) or
					((dot1.col == dot2.col) and (dot1.row == dot2.row + 1 or dot1.row == dot2.row -1))
	
	return result
end

-- Return line from dot1 to dot2
local function create_line(dot1, dot2)
	if not (dot1 == dot2) then
		local color = colors[dot1.type]
		local line = Shape.new()
		line:setLineStyle(6, color, 1)
		line:beginPath()
		line:moveTo(dot1:getX() + dot1:getWidth() * 0.5, dot1:getY() + dot1:getHeight() * 0.5)
		line:lineTo(dot2:getX() + dot2:getWidth() * 0.5, dot2:getY() + dot2:getHeight() * 0.5)
		line:endPath()
		line:closePath()
		
		return line
	end
end

-- Set up dots
function GameScene:draw_dots()

	--self.name = "mijuego"
	
	math.randomseed( os.time() )
	local board = Sprite.new()
	
	local posX = 15
	local posY = 200
	for i=1, num_rows do
		for j=1, num_columns do
			local dot_type = math.random(5)
			local dot = Bitmap.new(textures_types[dot_type])
			dot.enabled = true
			dot.type = dot_type
			dot.row = i
			dot.col = j
			dot:setScale(0.43)
			dot:setPosition(posX, posY)
			
			--Dot is pressed
			function dot:click(event)
				if dot:hitTestPoint(event.x, event.y) then
					event:stopPropagation()
					list = {} 
					list[1] = dot -- first dot
					self.current_dot = dot
					self.list = list
					
					--dot:setTexture(textures_types[6])
				end
			end
			
			-- Moving
			function dot:move(event)
				if dot:hitTestPoint(event.x, event.y) then
					event:stopPropagation()
					
					local list = self.list
					if (list) then
						-- Check if dot is already in the list
						local current_dot = self.current_dot
						
						if not (current_dot.type == dot.type) then -- distinct dot type
							self:rollback_dots()
						elseif (current_dot.type == dot.type and not (current_dot == dot))
								and isNeighbord(current_dot, dot) then	-- Same dot type
								
								--New dot only if dot already exists
								if not (table.contains(list, dot)) then
									--dot:setTexture(textures_types[6])
									--dot:setScale(0.5)
									table.insert(list, dot)
									self.current_dot = dot
									
									-- Draw one line to connect two dots
									local line = create_line(current_dot, dot)
									if line then
										self:addChild(line)
										local lines = self.lines
										lines[#lines + 1] = line
									end
								end
						end
					end
				end
			end
			
			-- When user release
			function dot:release(event)
				if dot:hitTestPoint(event.x, event.y) then
					event:stopPropagation()
					
					local list = self.list
					if (list) then
						if (#list >= 3) then
							self.hud:updateScore(list)
							
							self:deleteList()
						--else
							--self:rollback_dots()
						end	
					end
				end
				
				self:deleteTrack()
			end
					
			--[[
			Event.TOUCHES_BEGIN = “touchesBegin”
			Event.TOUCHES_MOVE = “touchesMove”
			Event.TOUCHES_END = “touchesEnd”
			Event.TOUCHES_CANCEL = “touchesCancel”
			]]--
			
			dot:addEventListener(Event.MOUSE_DOWN, dot.click, self)
			dot:addEventListener(Event.MOUSE_MOVE, dot.move, self)
			dot:addEventListener(Event.MOUSE_UP, dot.release, self)
			
			self:addChild(dot)
			posX = posX + dot:getWidth() + 24
		end
		
		posX = 15
		posY = posY + 70
	end
end

-- Draw score and time
function GameScene:draw_hud()
	local hud = Hud.new()
	self.hud = hud
	self:addChild(hud)
end

-- Dot is released
function GameScene:release(event)
	
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		self:rollback_dots()
	end
end

-- Remove dots list from scene when matching happens
function GameScene:deleteList()
	local list = self.list
	
	for i=1, #list do
		local dot = list[i]
		if (dot and self:contains(dot)) then
			self:removeChild(dot)
			self.list = nil
		end
	end
	
	-- Drop new dots from the top
	
end

-- Delete join track from memory and scene
function GameScene:deleteTrack()
	local lines = self.lines
	if (lines) then
		for i=1, #lines do
			print(i)
			local line = lines[i] -- a Shape segment
			if (line and self:contains(line)) then
				self:removeChild(line)
			end
		end
							
		self.lines = {}
	end
end

function GameScene:rollback_dots()
	local list = self.list
	if (list) then
		--Reset textures
		for key, value in pairs(list) do
			list[key]:setTexture(textures_types[value.type])
		end
	end
	
	--[[
	local line = self.line
	if (line and self:contains(line)) then
		self:removeChild(line)
	end
	]]--
	
end

local scene = GameScene.new()
stage:addChild(scene)
