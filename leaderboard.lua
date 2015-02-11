
LeaderBoardScene = Core.class(Sprite)
LeaderBoardScene.SCORE_FORMAT = "%08d"

function LeaderBoardScene.setup()
	LeaderBoardScene.font = getTTFont("fonts/new_academy.ttf", 40)
	LeaderBoardScene.font_rank = getTTFont("fonts/new_academy.ttf", 45)
	LeaderBoardScene.font_name = getTTFont("fonts/new_academy.ttf", 30)
	LeaderBoardScene.font_score = getTTFont("fonts/futur1.ttf", 36)
	
	-- Medals textures
	LeaderBoardScene.texture_medalgold = Texture.new("gfx/circle_yellow.png", true)
	LeaderBoardScene.texture_medalsilver = Texture.new("gfx/circle_blue.png", true)
	LeaderBoardScene.texture_medalbronze = Texture.new("gfx/circle_orange.png", true)

end

-- Return player ranking
function LeaderBoardScene:getPlayerRanking()
	local score_list = self.score_list -- friends score list
	local player_score = self.player_score -- current player score
	
	local rank = 1
	
	if (list and player_score) then
		for i=1, #list do
			local data = score_list[i]
			local score = data.score
			
			if (player_score > score) then
				rank = i
				break
			end
		end
	end
	
	return rank
end

-- Constructor
function LeaderBoardScene:init(score)
		
	self.player_score = score or 0
	self:addEventListener("enterEnd", self.onEnterEnd, self)
end

-- Show earned dots as title
function LeaderBoardScene:draw_header()
	
	--print("gameState", gameState)
	local num_coins = gameState.coins
	local text_dots = TextField.new(ScoreScene.font_points, num_coins)
	text_dots:setTextColor(0xFFD700)
	text_dots:setShadow(2, 1, 0x001100)
		
	text_dots:setPosition(210, 48)
	self:addChild(text_dots)
	
	self.text_dots = text_dots

	self:draw_dots()
	
	--[[
	local title = TextField.new(LeaderBoardScene.font, getString("leaderboards"), true)
	title:setTextColor(0x00B2EE)
	title:setShadow(2, 1, 0xff0000)
	local posX = (width - title:getWidth()) * 0.5
	title:setPosition(posX, 120)
	self:addChild(title)
	]]--
	
end

-- Draw some dots
function LeaderBoardScene:draw_dots()
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

-- Callback when login success
function LeaderBoardScene:loginResponse()

	if (social) then
		social:getUserInfo()
		social:getScores()
	end
end

function LeaderBoardScene:loginError()
	sceneManager:changeScene(scenes[3], 1, SceneManager.moveFromLeft, easing.linear)
end

-- Load friends scores from facebook on background
function LeaderBoardScene:onEnterEnd()
		
	if (social and not social:isConnected()) then
		social:login()
	else
		self:loginResponse()
	end
	
	self:draw_header()
	
	-- Score list for testing
	social = {userId = 10}
	self.score_list = {
						{user = {id = 1, name = "Pepito"}, score = 2000 },
						{user = {id = 2, name = "Juanito"}, score = 1500 },
						{user = {id = 3, name = "Daniel"}, score = 1200 },
						{user = {id = 4, name = "Jaime"}, score = 800 },
						{user = {id = 5, name = "Perico"}, score = 650 },
						{user = {id = 6, name = "David"}, score = 550 },
						{user = {id = 7, name = "Federico"}, score = 400 },
					}
	self:draw_list()
	
	--[[
	local texture_icon = TextureManager.texture_santaclaus
	local icon = Bitmap.new(texture_icon)
	icon:setScale(0.2)
	icon:setPosition(22, 0)
	self:addChild(icon)
	]]--
	
	--self:drawResume()
	--self:drawHome()
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
end

-- Draw friends scores and player score
function LeaderBoardScene:draw_list()
		
	local layer = Sprite.new()
	layer:setY(60)
	self:addChild(layer)
		
	local score_list = self.score_list
	local num_scores = math.min(#score_list, 6)
	local found = false
	
	for a = 1, num_scores do
		local data = self.score_list[a]
		local sprite = Sprite.new()
		--layer.next = sprite		
		
		local b = self:draw_row(sprite, a)
					
		-- Check if user is on top scores
		print(social.userId, data.user.id)
		if (not self.found and social.userId and social.userId == data.user.id) then
			self.found = true
			self.player_ranking = a
		end
						
		layer:addChildAt(sprite, 1)
		sprite:setPosition(0, b:getHeight())
		layer = sprite
	end
		
	--Player score is out of top friends score
	if (not self.found) then
		self.player_ranking = self:getPlayerRanking()
		local sprite = Sprite.new()
		local b = self:draw_row(sprite, self.player_ranking)
		layer:addChildAt(sprite, 1)
		sprite:setPosition(0, b:getHeight() + 6)
		layer = sprite
	end

end

-- Draw one score row
function LeaderBoardScene:draw_row(sprite, a)

	--[[
	local b = Shape.new()
	local width, height = application:getContentWidth() - 20, 50
	b:setFillStyle(Shape.SOLID, 0xffffff, 0.6)
	b:setLineStyle(1, 0x000000)
	b:beginPath()
	b:moveTo(15,0)
	b:lineTo(width, 0)
	b:lineTo(width, height)
	b:lineTo(15, height)
	b:lineTo(15, 0)
	b:endPath()
	sprite:addChild(b)
	]]--
	
	local width, height = application:getContentWidth() - 10, 60
	
	local b = Shape.new()
	b:setFillStyle(Shape.SOLID, 0xB9D3EE)
	b:setLineStyle(2, 0xF0FFF0)
	b:drawRoundRectangle(width, height , 20)
	sprite:addChild(b)
	
	local rank = TextField.new(LeaderBoardScene.font_rank, a)
	
	if a == 1 then -- Medal gold
		rank:setTextColor(0x0000ff)
		local medal = Bitmap.new(LeaderBoardScene.texture_medalgold)
		medal:setScale(0.5)
		medal:setPosition(5, -4)
		b:addChild(medal)
	elseif (a == 2) then -- Medal argent
		rank:setTextColor(0xffffff)
	
		local medal = Bitmap.new(LeaderBoardScene.texture_medalsilver)
		medal:setScale(0.5)
		medal:setPosition(5, -4)
		b:addChild(medal)
	elseif ( a == 3) then -- Medal bronze
		rank:setTextColor(0xffff00)
		local medal = Bitmap.new(LeaderBoardScene.texture_medalbronze)
		medal:setScale(0.5)
		medal:setPosition(5, -4)
		b:addChild(medal)
	end
	
	local posX = 36 - rank:getWidth() * 0.5
	rank:setPosition(posX, 15)
	b:addChild(rank)
	
	local data = self.score_list[a]
	local userId = data.user.id
	local firstname = data.user.name
	local score = data.score
	
	-- Username
	local title = TextField.new(LeaderBoardScene.font_name, firstname)
	title:setTextColor(0x00486e)
	title:setPosition(80, 16)
	b:addChild(title)
	
	-- Score
	title = TextField.new(LeaderBoardScene.font_score, score)
	title:setTextColor(0xA52A2A)
	title:setPosition(b:getWidth()-(title:getWidth() + 15), 16)
	b:addChild(title)
	
	b.scene = self
	
	return b
end

function LeaderBoardScene:draw_tab(posX, label)
	local square = Shape.new()
    local width, height = (application:getContentWidth() * 0.5) - 10, 30
	square:setFillStyle(Shape.SOLID, 0x483D8B, 1)
	square:setLineStyle(1, 0x000000)
    square:beginPath()
    square:moveTo(posX,0)
    square:lineTo(posX + width, 0)
    square:lineTo(posX + width, height)
    square:lineTo(posX, height)
    square:lineTo(posX, 0)
    square:endPath()
	
	local text = TextField.new(LeaderBoardScene.font, label)
	text:setTextColor(0xffffff)
	square:addChild(text)
	
	text:setPosition(posX + (width - text:getWidth()) * 0.5, 20)
	
	return square
	
end

-- Draw try again button
function LeaderBoardScene:drawResume()
	
	-- Resume button
	local icon_resume = Bitmap.new(TextureManager.texture_resume)
	icon_resume:setScale(0.5)
	
	local text_resume = TextField.new(ScoreScene.font_option, getString("try_again"))
	text_resume:setTextColor(0xff0000)
	text_resume:setShadow(1, 1, 0xffffff)
	text_resume:setPosition(-(text_resume:getWidth() - icon_resume:getWidth()) * 0.5, icon_resume:getHeight())
		
	local button_resume = Sprite.new()
	button_resume:setPosition(68, 340)
	
	button_resume:addChild(icon_resume)
	button_resume:addChild(text_resume)
	
	button_resume:addEventListener(Event.MOUSE_UP, 
								function(event)
									if (button_resume:hitTestPoint(event.x, event.y)) then
										event:stopPropagation()
										MenuScene.sound_push:play()
										sceneManager:changeScene(scenes[2], 0.5, SceneManager.fade, easing.linear)
									end
								end
							)
	self:addChild(button_resume)
end

-- Draw home button
function LeaderBoardScene:drawHome()

	-- Home button
	local icon_menu = Bitmap.new(TextureManager.texture_home)
	icon_menu:setScale(0.5)
	
	local button_home = Sprite.new()
	button_home:setPosition(174 , 340)
	button_home:addEventListener(Event.MOUSE_UP,
							function(event)
								if (button_home:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									MenuScene.sound_push:play()
									sceneManager:changeScene(scenes[1], 1, SceneManager.moveFromLeft, easing.OutBack)
								end
							end
						)
	self:addChild(button_home)
	
	button_home:addChild(icon_menu)
	
	local text_menu = TextField.new(ScoreScene.font_option, getString("main_menu"))
	text_menu:setTextColor(0x000000)
	text_menu:setShadow(1, 1, 0xffffff)
	text_menu:setPosition(-(text_menu:getWidth() - icon_menu:getWidth()) * 0.5, icon_menu:getHeight())
	button_home:addChild(text_menu)
	
	self:addChild(button_home)
end

-- When back button is pressed
function LeaderBoardScene:onKeyDown(event)
	
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		event:stopPropagation()
		sceneManager:changeScene(scenes[1], 1, SceneManager.fade, easing.linear)
	end
			
end