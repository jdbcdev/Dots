
ShopScene = Core.class(Sprite)

local width = application:getContentWidth()
local prefix = "jewel_"

function ShopScene.setup()

	--ShopScene.texture_bg = Texture.new("gfx/wallpaper3.jpg")
	ShopScene.texture_cart = Texture.new("gfx/shopping_cart_green.png", true)
	--ShopScene.texture_coin = Texture.new("gfx/jewel_red.png", true)
	
	ShopScene.font_title = TTFont.new("fonts/new_academy.ttf", 40)
	ShopScene.font_dots = TTFont.new("fonts/new_academy.ttf", 42)
	ShopScene.font_prize = TTFont.new("fonts/DroidSansFallback.ttf", 50)
end

-- Constructor
function ShopScene:init()

	self:draw_title()
	
	--Event listeners
	self:addEventListener("enterEnd", self.enterEnd, self)
end

-- When scene is loaded
function ShopScene:enterEnd()

	local posY = {106, 196, 286, 376, 486}
	local productPrices = Billing.getProductPrices() 
	if (android) then
		if productPrices then
			local a = 1
			for k,v in pairs(productPrices) do	
				local desc = string.gsub(k, "jewel_", "")
				self:createItem(desc, v, posY[a])
				a = a + 1
			end
		end
	else
		self:createItem("1000", "0.70 €", 106)
		self:createItem("3000", "1.45 €", 196)
		self:createItem("8000", "2.99 €", 286)
		self:createItem("20000", "3.99 €", 376)
		self:createItem("50000", "4.99 €", 486)
	end
	
	self:draw_ok()
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
end

-- Draw title of game shop
function ShopScene:draw_title()

	local text = TextField.new(ShopScene.font_title, "Get More Dots")
	text:setTextColor(0x1C86EE)
	text:setShadow(2,1,0x000000)
	local posX = (width - text:getWidth()) * 0.5
	text:setPosition(posX,30)
	self:addChild(text)
end

-- Create in-app purchase virtual item (coins)
function ShopScene:createItem(label, value, posY)
			
	local rect_width = width - 10
		
	local mesh = Mesh.new() 
	mesh:setVertices(1, 10, posY - 5, 2, rect_width, posY - 5, 3, rect_width, posY + 80, 4, 10,  posY + 80) 
	mesh:setIndexArray(1, 2, 3, 1, 3, 4) 
	local color = 0x5F9F9F
	mesh:setColorArray(color, 0.7, color, 0.7, color, 0.7, color, 0.7) 
	self:addChild(mesh)
		
	local sprite = Sprite.new()
	
	local text = TextField.new(ShopScene.font_dots, label)
	text:setTextColor(0xffff00)
	text:setShadow(2,1, 0x000000)
	text:setPosition(24, 24)
	sprite:addChild(text)
			
	local cart = Bitmap.new(ShopScene.texture_cart)
	cart:setScale(0.64, 0.64)
	cart:setPosition(360, 0)
	sprite:addChild(cart)
				
	sprite:addEventListener(Event.MOUSE_UP, 
							function(event)
								if (sprite:hitTestPoint(event.x, event.y)) then
									print("purchase", label, value)
									event:stopPropagation()
									
									Billing.purchase(prefix..label)
								end
							end)
								
	local prize = TextField.new(ShopScene.font_prize, value)
	--prize:setTextColor(0xff0000)
	prize:setTextColor(Colors.WHITE)
	prize:setShadow(2,1, 0x000000)
	prize:setPosition(270, 20)
	
	sprite:addChild(prize)
	self:addChild(sprite)
	sprite:setPosition(10, posY)
end

-- Draw OK button
function ShopScene:draw_ok()
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0xB9D3EE)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(200, 80, 40)
	group:addChild(border)

	local text = TextField.new(MenuScene.font_button, "OK")
	text:setTextColor(0xFFD700)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((200 - text:getWidth()) * 0.5, 30)
	group:addChild(text)
	
	group:setPosition(150, 590)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									SoundManager.play_effect(2)
									
									-- Back to previous scene
									sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
								end
							end)
end

-- Go back to menu when back key is pressed
function ShopScene:onKeyDown(event)
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		-- Back to main menu
		event:stopPropagation()
		sceneManager:changeScene(scenes[1], 1, SceneManager.fade, easing.linear)
	end
end