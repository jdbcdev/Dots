
LeaderBoardScene = Core.class(Sprite)

local MAX_PLAYERS = 5
local debug = false

--to check if file exists
function file_exists(name)
	local f=io.open(name,"r")
	
	if f then 
		io.close(f)
		return true 
	else 
		return false 
	end
end

-- Load user photo from Documents folder
function loadFBphoto(id)
	
	local file_name = "|D|"..id..".png"
	local texture
	
	-- Check file exists
	if file_exists(file_name) then
		print("el fichero existe")
		
		local success
		success, texture = pcall(Texture.new, file_name, true)
		
		-- if I was able to load it (has correct format)
		if not success then
			texture = nil
		end
	end
		
	-- if no texture, take default pic
	if not texture then
		texture = Texture.new("gfx/user_default.jpg", true)
	end
	
	return Bitmap.new(texture)
end

function LeaderBoardScene.setup()
	LeaderBoardScene.font = getTTFont("fonts/new_academy.ttf", 40)
	LeaderBoardScene.font_rank = getTTFont("fonts/new_academy.ttf", 45)
	LeaderBoardScene.font_name = getTTFont("fonts/new_academy.ttf", 30)
	LeaderBoardScene.font_score = TTFont.new("fonts/futur1.ttf", 36)
	
	-- Medals textures
	LeaderBoardScene.texture_medalgold = Texture.new("gfx/circle_yellow.png", true)
	LeaderBoardScene.texture_medalsilver = Texture.new("gfx/circle_blue.png", true)
	LeaderBoardScene.texture_medalbronze = Texture.new("gfx/circle_orange.png", true)

end

-- Return player ranking
function LeaderBoardScene:getPlayerRanking()
	
	local list = self.score_list -- friends score list

	local rank = #list -- Last position as default
	
	if (list) then
		for i=1, #list do
			local data = list[i]
			local score = data.score
		
			-- Check if userid and score matches
			if (social.userId == data.user.id) then
				rank = i
				break
			end
		end
	end
	
	return rank
end

-- Constructor
function LeaderBoardScene:init()
	
	self:addEventListener("enterEnd", self.onEnterEnd, self)
end

-- Load friends scores from facebook on background
function LeaderBoardScene:onEnterEnd()
	
	if (social and (not social.connected)) then
		social:login()
	else
		self:loginResponse()
	end
	
	self:draw_header()
	self:draw_ok()
	
	-- Score list for testing
	if (debug) then
		social = {userid = 5}
		self.score_list = {
						{user = {id = 1, name = "Pepito"}, score = 2000 },
						{user = {id = 2, name = "Juanito"}, score = 1500 },
						{user = {id = 3, name = "Daniel"}, score = 1200 },
						{user = {id = 4, name = "Jaime"}, score = 800 },
						{user = {id = 5, name = "Perico"}, score = 650 },
						{user = {id = 6, name = "David"}, score = 550 },
						{user = {id = 7, name = "Federico"}, score = 400 },
						{user = {id = 10, name = "Federico"}, score = 100 },
					}
		self:draw_list()
	end
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
end


-- Show earned dots as title
function LeaderBoardScene:draw_header()
	
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
		--social:getUserInfo()
		social:getScores()
	end
end

function LeaderBoardScene:loginError()
	--sceneManager:changeScene(scenes[3], 1, SceneManager.fade, easing.linear)
end

-- Draw player and friends scores
function LeaderBoardScene:draw_list()
	
	local layer = Sprite.new()
	layer:setPosition(5, 60)
	self:addChild(layer)
	
	-- Show list if there is
	local score_list = self.score_list
		
	if (score_list and #score_list > 0) then
		local num_scores = math.min(#score_list, MAX_PLAYERS)
		self.found = false
	
		print("num_scores", num_scores)
	
		for a = 1, num_scores do
			local sprite = Sprite.new()		
			local b = self:draw_row(sprite, a)
											
			layer:addChildAt(sprite, 1)
			sprite:setPosition(0, b:getHeight())
			layer = sprite
		end
	
		--Player score is out of top friends score
		if (not self.found) then
			local player_ranking = self:getPlayerRanking()
			local sprite = Sprite.new()
			local b = self:draw_row(sprite, player_ranking)
			layer:addChildAt(sprite, 1)
			sprite:setPosition(0, b:getHeight() + 6)
			layer = sprite
		end
	else
		print("Empty list")
	end
	
end


-- Draw one score row
function LeaderBoardScene:draw_row(sprite, a)
	
	local width, height = application:getContentWidth() - 10, 70
	local data = self.score_list[a]
	
	local b = Shape.new()
	
	-- Check if user is on top scores
	--print(social.userid, data.user.id)
	if (not self.found and social.userid and social.userid == data.user.id) then
		self.found = true
		self.player_ranking = a
		
		b:setFillStyle(Shape.SOLID, 0x1E90FF)
	elseif (a > MAX_PLAYERS) then
		b:setFillStyle(Shape.SOLID, 0x1E90FF)
	else
		b:setFillStyle(Shape.SOLID, 0xB9D3EE)
	end
	
	b:setLineStyle(2, 0xF0FFF0)
	b:drawRoundRectangle(width, height , 20)
	sprite:addChild(b)

	local rank = TextField.new(LeaderBoardScene.font_rank, a)
	
	if (a == 1) then -- Medal gold
		rank:setTextColor(0x0000ff)
		local medal = Bitmap.new(LeaderBoardScene.texture_medalgold)
		medal:setScale(0.5)
		medal:setPosition(5, -4)
		b:addChild(medal)
	elseif (a == 2) then -- Medal silver
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
	local text_name = TextField.new(LeaderBoardScene.font_name, string.sub(firstname,1, 12))
	if (a > MAX_PLAYERS or (social.userid and social.userid == data.user.id)) then
		text_name:setTextColor(0xffffff)
	else
		text_name:setTextColor(0x00486e)
	end
	
	text_name:setPosition(150, 5)
	b:addChild(text_name)
	
	-- User photo
	--local photo = Bitmap.new(Texture.new("gfx/user_default.jpg"))
	local photo = loadFBphoto(data.user.id)				
	photo:setPosition(85, 6)
	b:addChild(photo)
	
	-- Score
	local text_score = TextField.new(LeaderBoardScene.font_score, score)
	text_score:setTextColor(0xF52A2A)
	text_score:setShadow(2,1, 0x000000)
	text_score:setPosition(b:getWidth() * 0.5 -text_score:getWidth() *  0.5 + 30, 30)
	b:addChild(text_score)
	
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

-- Draw OK button
function LeaderBoardScene:draw_ok()
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0x5F9F9F)
	border:setLineStyle(2, Colors.BLACK)
	border:drawRoundRectangle(200, 80, 0)
	group:addChild(border)

	local text = TextField.new(MenuScene.font_button, "OK")
	text:setTextColor(Colors.WHITE)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((200 - text:getWidth()) * 0.5, 30)
	group:addChild(text)
	
	group:setPosition(150, 620)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									SoundManager.play_effect(2)
									sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
								end
							end)
end

-- Show Facebook invite icon
function LeaderBoardScene:showInvitation()
	
	local width, height = application:getContentWidth() - 20, 200
	
	local sprite = Sprite.new()
	local b = Shape.new()	
	
	b:setFillStyle(Shape.SOLID, 0xB9D3EE)
	b:setLineStyle(2, 0x000000)
	b:drawRoundRectangle(width, height , 20)
	sprite:addChild(b)
	
	sprite:setPosition(10, 220)
	self:addChild(sprite)
	
	local text = TextField.new(LeaderBoardScene.font_name, "Invite to friends")
	local posX = (sprite:getWidth() - text:getWidth()) * 0.5
	text:setPosition(posX, 20)
	sprite:addChild(text)
end

-- When back button is pressed
function LeaderBoardScene:onKeyDown(event)
	
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		event:stopPropagation()
		sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
	end
			
end
