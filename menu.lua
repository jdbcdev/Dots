
MenuScene = Core.class(Sprite)

local width = application:getContentWidth()

-- Return a square shape
function create_square(size, color)
	local shape = Shape.new()
	shape:setFillStyle(Shape.SOLID, color)
	shape:drawRoundRectangle(size, size, 0)
	
	return shape
end

function MenuScene.setup()
	
	--Textures
	MenuScene.texture_shop = Texture.new("gfx/shopping_cart_green.png", true)
	MenuScene.texture_play = Texture.new("gfx/play.png", true)
	MenuScene.texture_facebook = Texture.new("gfx/logo_fb.png", true)
	MenuScene.texture_medal = Texture.new("gfx/medal.png", true)
	
	MenuScene.font_title = TTFont.new("fonts/new_academy.ttf", 90)
	MenuScene.font_button = TTFont.new("fonts/new_academy.ttf", 34)
end

-- Constructor
function MenuScene:init() 
		
	self:draw_title()
	
	self:addEventListener("enterEnd", self.enterEnd, self)
	
end

-- When menu scene is loaded
function MenuScene:enterEnd()
		
	self:draw_start()
		
	Advertise.showInterstitial()
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
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
	
	local title1 = TextField.new(MenuScene.font_title, "Square")
	title1:setTextColor(0x483D8B)
	title1:setShadow(2, 2, 0x000000)
	title1:setPosition((width - title1:getWidth()) * 0.5, 120)
	self:addChild(title1)
	
	local title2 = TextField.new(MenuScene.font_title, "Dots")
	title2:setTextColor(0x1C86EE)
	title2:setShadow(2, 2, 0x001100)
	title2:setPosition((width - title2:getWidth()) * 0.5, 340)
	self:addChild(title2)
	
	self:draw_dots()
end

-- Draw some dots
function MenuScene:draw_dots()
	local coords = {
					{188, 200, 0x007FFF},
					{262, 200, 0xFF0000},
					{188, 270, 0xFFA500},
					{262, 270, 0x228B22}
					}
					
	for a=1, #coords do
		local coord = coords[a]
		local posX, posY, color = coord[1], coord[2], coord[3]
		local dot = create_square(50, color)
		dot:setPosition(posX, posY)
		self:addChild(dot)
	end
end

-- Draw start button
function MenuScene:draw_start()
	
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0xB9D3EE)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(280, 100, 40)
	group:addChild(border)

	local text = TextField.new(MenuScene.font_button, getString("start"))
	text:setTextColor(0xFFD700)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((280 - text:getWidth()) * 0.5, 46)
	group:addChild(text)
	
	group:setPosition(100, 480)
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

function MenuScene:draw_login()
	
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