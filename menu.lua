
MenuScene = Core.class(Sprite)

local width = application:getContentWidth()

-- Return a square shape
local function create_square(color)
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, color)
	shape:drawRoundRectangle(50, 50, 0)
	
	return shape
end

function MenuScene.setup()
	
	--Textures
	--MenuScene.texture_bg = textures:getTextureRegion("halloween_house.png")
	
	MenuScene.font_title = TTFont.new("fonts/new_academy.ttf", 90)
	MenuScene.font_play = TTFont.new("fonts/new_academy.ttf", 30)
end

-- Constructor
function MenuScene:init() 
	
	--application:setBackgroundColor(0x222222)
	
	--self:draw_bg()
	self:draw_title()
	
	self:addEventListener("enterEnd", self.enterEnd, self)
	
end

-- When menu scene is loaded
function MenuScene:enterEnd()
	
	self:draw_buttons()
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	
	--Advertise.showBanner()
end

-- Draw menu background
function MenuScene:draw_bg()
	local bg = Bitmap.new(MenuScene.texture_bg)
	self:addChild(bg)
	
	local witch = Bitmap.new(MenuScene.texture_witch)
	witch:setScale(0.8)
	witch:setPosition(220, 190)
	self:addChild(witch)
	
	local tween1 = GTween.new(witch, 6, {x = 10},{ease = easing.linear})
	local tween2 = GTween.new(witch, 6, {x = 180},{ease = easing.linear, autoPlay = false})
	tween1.nextTween = tween2
	tween2.nextTween = tween1
		
	local cat = Bitmap.new(GameScene.texture_cat)
	cat:setScale(0.6)
	cat:setPosition(130, 94)
	self:addChild(cat)
	
end

-- Draw title
function MenuScene:draw_title()
	
	--local title1 = TextField.new(MenuScene.font_title, "Atoms")
	local title1 = TextField.new(MenuScene.font_title, "Squares")
	title1:setTextColor(0x000000)
	title1:setShadow(2, 1, 0x38B0DE)
	title1:setPosition((width - title1:getWidth()) * 0.5, 120)
	self:addChild(title1)
	
	self:draw_dots()
end

-- Draw some dots
function MenuScene:draw_dots()
	local coords = {
					{170, 200, 0x007FFF},
					{280, 200, 0xFF0000},
					{170, 270, 0xFFA500},
					{280, 270, 0x228B22}
					}
	local a
	for a=1, #coords do
		local coord = coords[a]
		local posX, posY, color = coord[1], coord[2], coord[3]
		local dot = create_square(color)
		dot:setPosition(posX, posY)
		self:addChild(dot)
	end
end

-- Draw play button
function MenuScene:draw_buttons()
	
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0x483D8B)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(280, 100, 40)
	group:addChild(border)

	local text = TextField.new(MenuScene.font_play, "Play now")
	text:setTextColor(0xffffff)
	--text:setShadow(2, 1, 0x38B0DE)
	text:setPosition((280 - text:getWidth()) * 0.5, 46)
	group:addChild(text)
	
	group:setPosition(100, 450)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									sceneManager:changeScene(scenes[2], 1, SceneManager.fade, easing.linear)
								end
							end)
	
	--[[
	icon_play:addEventListener(Event.MOUSE_UP, 
								function(event)
									if (icon_play:hitTestPoint(event.x, event.y)) then
										event:stopPropagation()
										MenuScene.sound_push:play()
										icon_play:setVisible(false)
										sceneManager:changeScene(scenes[2], 1.5, SceneManager.moveFromRight, easing.OutBack)
									end
								end)]]--
end

-- When back button is pressed
function MenuScene:onKeyDown(event)
	
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