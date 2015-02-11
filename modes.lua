
GameModeScene = Core.class(Sprite)

local width = application:getContentWidth()

-- Constructor
function GameModeScene:init()
	self:draw_title()
	
	self:addEventListener("enterEnd", self.enterEnd, self)
end

-- When menu scene is loaded
function GameModeScene:enterEnd(event)
	self:draw_play()
	self:draw_shop()
	
	self:draw_comment()
	self:draw_panel()
end

-- Show earned dots as title
function GameModeScene:draw_title()
	
	--print("gameState", gameState)
	local num_coins = gameState.coins
	local text_dots = TextField.new(ScoreScene.font_points, num_coins)
	text_dots:setTextColor(0xFFD700)
	text_dots:setShadow(2, 1, 0x001100)
		
	text_dots:setPosition(210, 48)
	self:addChild(text_dots)
	
	self.text_dots = text_dots

	self:draw_dots()
end

-- Draw some dots
function GameModeScene:draw_dots()
	local coords = {
					{140, 40, 0x007FFF},
					{165, 40, 0xFF0000},
					{140, 65, 0xFFA500},
					{165, 65, 0x228B22}
					}
	local a
	for a=1, #coords do
		local coord = coords[a]
		local posX, posY, color = coord[1], coord[2], coord[3]
		local dot = create_square(20, color)
		dot:setPosition(posX, posY)
		self:addChild(dot)
	end
end

-- Draw play button
function GameModeScene:draw_play()
	
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0xB9D3EE)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(280, 100, 40)
	group:addChild(border)
	
	local icon = Bitmap.new(MenuScene.texture_play)
	icon:setScale(0.5)
	icon:setPosition(10, 20)
	group:addChild(icon)
	
	local text = TextField.new(MenuScene.font_button, getString("play"))
	text:setTextColor(0xFFD700)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((280 - text:getWidth()) * 0.6, 46)
	group:addChild(text)
	
	group:setPosition(100, 480)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									SoundManager.play_effect(7)
									sceneManager:changeScene(scenes[2], 1, SceneManager.fade, easing.linear)
								end
							end)
end

-- Draw shop button
function GameModeScene:draw_shop()
	
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0x00B2EE)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(280, 100, 40)
	group:addChild(border)
	
	local icon = Bitmap.new(MenuScene.texture_shop)
	icon:setScale(0.5)
	icon:setPosition(10, 20)
	group:addChild(icon)
	
	local text = TextField.new(MenuScene.font_button, getString("shop"))
	text:setTextColor(0xFFD700)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((280 - text:getWidth()) * 0.6, 46)
	group:addChild(text)
	
	group:setPosition(100, 350)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									SoundManager.play_effect(6)
									sceneManager:changeScene(scenes[3], 1, SceneManager.fade, easing.linear)
								end
							end)
end

-- Draw Add powerup comment
function GameModeScene:draw_comment()

	local text = TextField.new(MenuScene.font_button, getString("add_powerup"))
	text:setTextColor(0x1C86EE)
	text:setShadow(2, 1, 0x000000)
	local posX = (width - text:getWidth()) * 0.5
	text:setPosition(posX, 610)
	self:addChild(text)
end

-- Draw powerups panel
function GameModeScene:draw_panel()
	PowerupScene.draw_panel(self, true)
end

-- When back button is pressed
function GameModeScene:onKeyDown(event)
	
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		event:stopPropagation()
		
		local alertDialog = AlertDialog.new(getString("quit"), getString("sure"), getString("cancel"), getString("yes"))
	
		alertDialog:addEventListener(Event.COMPLETE, 
										function(event)
											if (event.buttonIndex) then
												application:exit()
											end
										end)
		alertDialog:show()
	end
end