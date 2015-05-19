
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
	
	-- Facebook login button
	if (social) then
		if (social:wasConnected()) then
			self:draw_leaderboard()
		else
			self:draw_login()
		end
	else	
		self:draw_leaderboard()
	end
	
	self:draw_comment()
	self:draw_panel()
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
end

-- Show earned dots as title
function GameModeScene:draw_title()
	
	--print("gameState", gameState)
	local num_dots = gameState.dots
	local text_dots = TextField.new(ScoreScene.font_points, num_dots)
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
	text:setTextColor(0xFFFFFF)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((280 - text:getWidth()) * 0.6, 46)
	group:addChild(text)
	
	--group:setPosition(100, 480)
	group:setPosition(100, 380)
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


-- Draw Facebook login button
function GameModeScene:draw_login()
	
	local group = Sprite.new()
	
	local border = Shape.new()
	--border:setFillStyle(Shape.SOLID, 0xFF7F24)
	--border:setLineStyle(2, 0xF0FFF0)
	border:setFillStyle(Shape.SOLID, 0x00B2EE)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(280, 100, 40)
	group:addChild(border)
	
	local icon = Bitmap.new(MenuScene.texture_facebook)
	icon:setScale(0.5)
	icon:setPosition(10, 20)
	group:addChild(icon)
	
	local text = TextField.new(MenuScene.font_button, getString("login"))
	text:setTextColor(0xFFFFFF)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((280 - text:getWidth()) * 0.6, 46)
	group:addChild(text)
	
	group:setPosition(100, 210)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									SoundManager.play_effect(6)
									if (social) then
										social:login()
									end
								end
							end)
							
	self.button_login = group
end

-- Draw leaderboard button
function GameModeScene:draw_leaderboard()
		
	local group = Sprite.new()
	
	local border = Shape.new()
	--border:setFillStyle(Shape.SOLID, 0xFF7F24)
	--border:setLineStyle(2, 0xF0FFF0)
	border:setFillStyle(Shape.SOLID, 0x00B2EE)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(300, 100, 40)
	group:addChild(border)
	
	local icon = Bitmap.new(MenuScene.texture_medal)
	icon:setScale(0.5)
	icon:setPosition(10, 20)
	group:addChild(icon)
	
	local text = TextField.new(MenuScene.font_button, getString("score"))
	text:setTextColor(0xFFFFFF)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((300 - text:getWidth()) * 0.6, 46)
	group:addChild(text)
	
	group:setPosition(90, 210)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									SoundManager.play_effect(1)
									sceneManager:changeScene(scenes[7], 1, SceneManager.fade, easing.linear, {userData=3000})
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

-- Login callback
function GameModeScene:onLoginComplete()
	-- Replace login button with score button
	if (self.button_login) then
		self:removeChild(self.button_login)
		self.button_login = nil
	end
	
	self:draw_leaderboard()
end

-- Back to menu when back button is pressed
function GameModeScene:onKeyDown(event)
	
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		
		event:stopPropagation()
		self:removeEventListener(Event.KEY_DOWN, self.onKeyDown, self)
		sceneManager:changeScene(scenes[1], 1, SceneManager.fade, easing.linear)
	end
end