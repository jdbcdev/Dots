
Dot = Core.class(Sprite)

local textures_types = {
						Texture.new("gfx/circle_yellow.png", true),
						Texture.new("gfx/circle_red.png", true),
						Texture.new("gfx/circle_orange.png", true),
						Texture.new("gfx/circle_green.png", true),
						Texture.new("gfx/circle_blue.png", true),
						Texture.new("gfx/circle_grey.png", true)
						}

-- Constructor
function Dot:init(row, col)
	local dot_type = math.random(5)
	local dot = Bitmap.new(textures_types[dot_type])
	self.enabled = true
	self.type = dot_type
	self.row = row
	self.col = col
	self:setScale(0.43)
	self:addChild(dot)
	
	self:addEventListener(Event.MOUSE_DOWN, self.click, self)
	self:addEventListener(Event.MOUSE_MOVE, self.move, self)
	self:addEventListener(Event.MOUSE_UP, self.release, self)
end

--Dot is pressed
function Dot:click(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		list = {} 
		list[1] = dot -- first dot
		self.current_dot = dot
		self.list = list
	end
end

-- Moving dot while screen is pressed
function Dot:move(event)
	if self:hitTestPoint(event.x, event.y) then
		local scene = dot:getParent()
		event:stopPropagation()
					
		-- TODO 
		local list = scene.list
		if (list) then
			-- Check if dot is already in the list
			local current_dot = scene.current_dot
			if not (current_dot.type == self.type) then -- distinct dot type
				scene:rollback_dots()
			elseif (current_dot.type == dot.type and not (current_dot == dot))
					and isNeighbord(current_dot, dot) then	-- Same dot type
								
				--New dot only if dot already exists
				if not (table.contains(list, dot)) then
					table.insert(list, dot)
					scene.current_dot = dot
									
					-- Draw one line to connect two dots
					local line = create_line(current_dot, dot)
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

-- When user release
function Dot:release(event)
	if self:hitTestPoint(event.x, event.y) then
		event:stopPropagation()
		
		local scene = self:getParent()
		local list = scene.list
		if (list) then
			if (#list >= 3) then
				scene.hud:updateScore(list)
				scene:deleteList()
			end	
		end
	end
	
	scene:deleteTrack()
end

function Dot:setBoard(row, col)
	self.row = row
	self.col = col
end