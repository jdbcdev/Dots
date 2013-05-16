
GameScene = Core.class(Sprite)

local textures_types = {Texture.new("gfx/1_gems.png"),
						Texture.new("gfx/2_gems.png"),
						Texture.new("gfx/3_gems.png"),
						Texture.new("gfx/4_gems.png"),
						Texture.new("gfx/7_gems.png")}
						
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function GameScene:init()
	self:draw_background()
	self:draw_dots()
	
	--Event listeners
	self:addEventListener(Event.MOUSE_UP, GameScene.release, self)
end

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

function GameScene:draw_dots()

	self.name = "mijuego"
	
	math.randomseed( os.time() )
	local board = Sprite.new()
	
	local posX = 25
	local posY = 120
	for i=1,6 do
		for j=1,6 do
			local dot_type = math.random(4)
			local dot = Bitmap.new(textures_types[dot_type])
			dot.name = "dot"
			dot.type = dot_type
			dot.row = i
			dot.col = j
			dot:setScale(0.43)
			dot:setPosition(posX, posY)
			
			--Dot is pressed
			function dot:click(e)
				if dot:hitTestPoint(e.x, e.y) then
					e:stopPropagation()
					list = {} 
					list[1] = dot -- first dot
					self.current_dot = dot
					self.list = list
					
					dot:setTexture(textures_types[5])
					--print ("#list ", #list)
				end
			end
			
			-- Moving
			function dot:move(e)
				if dot:hitTestPoint(e.x, e.y) then
					e:stopPropagation()
					--print ("self.name ", self.name)
					--print ("dot.name ", dot.name)
					
					local list = self.list
					if (list) then
						-- Check if dot is already in the list
						local current_dot = self.current_dot
						
						if not (current_dot.type == dot.type) then
							print ("Distinto color")
							self:rollback_dots()
						elseif current_dot.type == dot.type and not (current_dot == dot)  then	
								
								--New dot only if dot already exists
								
								if not (table.contains(list, dot)) then
									dot:setTexture(textures_types[5])
									table.insert(list, dot)
									self.current_dot = dot
							
									--print ("#list ", #list)
								else
									print ("repetido")
								end
						end
					end
				end
			end
			
			--[[
			Event.TOUCHES_BEGIN = “touchesBegin”
			Event.TOUCHES_MOVE = “touchesMove”
			Event.TOUCHES_END = “touchesEnd”
			Event.TOUCHES_CANCEL = “touchesCancel”
			]]--
			
			dot:addEventListener(Event.MOUSE_DOWN, dot.click, self)
			dot:addEventListener(Event.MOUSE_MOVE, dot.move, self)
			--dot:addEventListener(Event.MOUSE_UP, dot.release, self)
			
			self:addChild(dot)
			posX = posX + dot:getWidth() + 20
		end
		
		posX = 25
		posY = posY + 70
	end
end

-- Dot is released
function GameScene:release(e)
	
	if self:hitTestPoint(e.x, e.y) then
		e:stopPropagation()
		self:rollback_dots()
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
end

local scene = GameScene.new()
stage:addChild(scene)
