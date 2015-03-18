
ScoreScene = Core.class(Sprite)

local width = application:getContentWidth()
local height = application:getContentHeight() 

function ScoreScene.setup()

	-- True type fonts
	ScoreScene.font_title = getTTFont("fonts/new_academy.ttf", 42, 36)
	ScoreScene.font_highscore = getTTFont("fonts/new_academy.ttf", 44, 36)
	ScoreScene.font_points = TTFont.new("fonts/new_academy.ttf", 50)
	ScoreScene.font_points2 = TTFont.new("fonts/new_academy.ttf", 62)
	ScoreScene.font_option = getTTFont("fonts/new_academy.ttf", 24)
end

-- Constructor
function ScoreScene:init(points)
		
	self.points = points or 0
	self.powerup_text = {}
	self.powerup_button = {}
		
	self:addEventListener("enterEnd", self.enterEnd, self)
	self:addEventListener("exitBegin", self.exitBegin, self)
end

-- When scene has been loaded
function ScoreScene:enterEnd()	
		
	self:draw_title()
	self:draw_score()
	self:draw_play()
	self:draw_comment()
	self:draw_panel()
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	
	--Advertise.showInterstitial()
end

function ScoreScene:exitBegin()
	
	self:removeEventListener(Event.KEY_DOWN, self.onKeyDown, self)
end

-- Show earned dots as title
function ScoreScene:draw_title()
	
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
function ScoreScene:draw_dots()
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

-- Show score and highscore
function ScoreScene:draw_score()
	
	local posY = 105
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0xB9D3EE)
	border:setLineStyle(2, Colors.BLACK)
	border:drawRoundRectangle(width-20, 250, 20)
	self:addChild(border)
	
	border:setPosition(10, posY)
		
	-- Check highscore
	local points = self.points
	local highscore = gameState.highscore
	if (points > highscore) then
		
		-- New highscore
		gameState:saveHighscore(points)
		
		local text_title2 = TextField.new(ScoreScene.font_highscore, getString("best_score"))
		text_title2:setTextColor(Colors.PALEGREEN)
		text_title2:setShadow(2, 1, Colors.BLACK)
		local posX = (width - text_title2:getWidth()) * 0.5
		text_title2:setPosition(posX, posY + 60)
		self:addChild(text_title2)
		
		local text_score = TextField.new(ScoreScene.font_points2, points)
		text_score:setTextColor(Colors.WHITE)
		text_score:setShadow(2,1, Colors.RED)
		posX = (width - text_score:getWidth()) * 0.5
		text_score:setPosition(posX, posY + 140)
		self:addChild(text_score)
	else
		-- Current score
		local text_title = TextField.new(ScoreScene.font_title, getString("your_score"))
		text_title:setTextColor(Colors.PALEGREEN)
		text_title:setShadow(2, 1, Colors.BLACK)
		local posX = (width - text_title:getWidth()) * 0.5
		text_title:setPosition(posX, posY + 25)
		self:addChild(text_title)
	
		local text_score = TextField.new(ScoreScene.font_points, points)
		text_score:setTextColor(Colors.WHITE)
		text_score:setShadow(2,1, Colors.RED)
		posX = (width - text_score:getWidth()) * 0.5
		text_score:setPosition(posX, posY + 85)
		self:addChild(text_score)
		
		-- Highscore
		local text_title2 = TextField.new(ScoreScene.font_title, getString("best_score"))
		text_title2:setTextColor(Colors.ORANGE)
		text_title2:setShadow(2, 1, Colors.BLACK)
		local posX = (width - text_title2:getWidth()) * 0.5
		text_title2:setPosition(posX, posY + 140)
		self:addChild(text_title2)
	
		local text_highscore = TextField.new(ScoreScene.font_points, highscore)
		text_highscore:setTextColor(Colors.WHITE)
		text_highscore:setShadow(2,1, Colors.RED)
		posX = (width - text_highscore:getWidth()) * 0.5
		text_highscore:setPosition(posX, posY + 200)
		self:addChild(text_highscore)
	end
end


-- Draw play button
function ScoreScene:draw_play()
	
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0x5F9F9F)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(200, 80, 40)
	group:addChild(border)

	local text = TextField.new(MenuScene.font_button, "OK")
	text:setTextColor(0xFFD700)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((200 - text:getWidth()) * 0.5, 30)
	group:addChild(text)
	
	group:setPosition(150, 420)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									SoundManager.play_effect(1)
									sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
								end
							end)
end

-- Draw Add powerup comment
function ScoreScene:draw_comment()

	local text = TextField.new(MenuScene.font_button, getString("add_powerup"))
	text:setTextColor(0x1C86EE)
	text:setShadow(2, 1, 0x000000)
	local posX = (width - text:getWidth()) * 0.5
	text:setPosition(posX, 610)
	self:addChild(text)
end

-- Draw powerups panel
function ScoreScene:draw_panel()
	PowerupScene.draw_panel(self)
end

-- Show powerup scene for given index
function ScoreScene:show_powerup(index)
	
	sceneManager:changeScene(scenes[5], 1, SceneManager.fade, easing.linear, {userData = index} )
	
	--[[
	local shop = PowerupScene.new(index)
	self:addChild(shop)
	self.shop = shop
	
	shop:enterEnd()
	]]--
end

-- More powerups added by user
function ScoreScene:add_powerup(index, num)
	
	local text = self.powerup_text[index]
	local num = tonumber(text:getText()) + 5
	text:setText(num)
	
	local button = self.powerup_button[index]
	local posX = button:getX() + (button:getWidth() - text:getWidth()) * 0.5
	text:setX(posX)
	
	-- Change button icon texture
	if (num > 0) then
		local texture = Hud.texture_powerup[index]
		self.powerup_button[index].upState:setTexture(texture[1])
	end
end

-- Check if Android back button is pressed
function ScoreScene:onKeyDown(event)
	
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		event:stopPropagation()
		
		sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
	end
end