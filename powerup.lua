
PowerupScene = Core.class(Sprite)

local max_powerup = 9995
local width = application:getContentWidth()

function PowerupScene.setup()
	local content = {}
	content[1] = {title = "moves_5", 
				icon = Hud.texture_powerup[1][1],
				price = 1000
			}

	content[2] = {title = "trash_dot",
				icon = Hud.texture_powerup[2][1],
				price = 500
			}
			
	content[3] = {title = "diagonal",
				icon = Hud.texture_powerup[3][1],
				price = 5000
			}
			
	PowerupScene.content = content
	PowerupScene.font_title = TTFont.new("fonts/new_academy.ttf", 40)
	PowerupScene.font_item = getTTFont("fonts/new_academy.ttf", 30)
	PowerupScene.font_desc = getTTFont("fonts/new_academy.ttf", 25)
end

-- Constructor
function PowerupScene:init(index)
	
	self.index = index or 1
	self:draw_title()
	
	--Event listeners
	self:addEventListener("enterEnd", self.enterEnd, self)
end

-- When scene is loaded
function PowerupScene:enterEnd()
	local index = self.index
	
	self:draw_item(index)
	self:draw_buttons(index)
	--self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	
	Advertise.showBanner()
end

-- Draw title of game shop
function PowerupScene:draw_title()

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
function PowerupScene:draw_dots()
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

-- Draw powerup icon and description
function PowerupScene:draw_item(index)
		
	local content = PowerupScene.content
		
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0xB9D3EE)
	border:setLineStyle(2, Colors.BLACK)
	border:drawRoundRectangle(width-10, 320, 0)
	self:addChild(border)
	
	border:setPosition(5, 115)
		
	-- Help text item
	local text = TextField.new(PowerupScene.font_item, getString(content[index].title))
	text:setTextColor(0xffff00)
	text:setShadow(2,1,0x000000)
	local posX = (width - text:getWidth()) * 0.5
	text:setPosition(posX, 140)
	self:addChild(text)
	
	-- Item description
	local desc = TextField.new(PowerupScene.font_desc, getString("desc"..index))
	desc:setTextColor(0xADEAEA)
	desc:setShadow(2,1,0x000000)
	local posX = (width - desc:getWidth()) * 0.5
	desc:setPosition(posX, 400)
	self:addChild(desc)
	
	-- Item icon
	local icon = Bitmap.new(content[index].icon)
	icon:setScale(1)
	posX = (width - icon:getWidth()) * 0.5
	icon:setPosition(posX, 190)
	self:addChild(icon)	
	
	-- Number of items you have
	local powerup_num = gameState.powerups
	local index = self.index
	
	local number_items = TextField.new(ScoreScene.font_points, powerup_num[index])
	number_items:setTextColor(0xFFFFFF)
	number_items:setShadow(2, 1, 0x000000)
	posX = (width - number_items:getWidth()) * 0.5
	number_items:setPosition(posX, 340)
	self:addChild(number_items)
	
	self.number_items = number_items
end

-- Draw button
function PowerupScene:draw_buttons()
	
	self:draw_price()
	self:draw_ok()
	
end

-- Draw price button
function PowerupScene:draw_price()
	
	local index = self.index
	local content = PowerupScene.content
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0x00B2EE)
	border:setLineStyle(2, Colors.BLACK)
	border:drawRoundRectangle(400, 100, 0)
	group:addChild(border)

	local text = TextField.new(MenuScene.font_button, "5 X "..content[index].price.."  "..getString("dots"))
	text:setTextColor(0xFFD700)
	text:setShadow(3, 1, 0x000000)
	local posX = (400 - text:getWidth()) * 0.5
	text:setPosition(posX, 40)
	group:addChild(text)
	
	group:setPosition(40, 470)
	self:addChild(group)
	group:addEventListener(Event.MOUSE_DOWN,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									text:setTextColor(Colors.WHITE)
									text:setShadow(3, 1, 0x000000)
								end
							end
							)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									
									text:setTextColor(0xFFD700)
									text:setShadow(3, 1, 0x000000)
									
									local price = content[index].price
																		
									-- You get more powerups if you have enough dots and less than 9995
									if (gameState.dots >= price and gameState.powerups[index] < max_powerup)then
											
										SoundManager.play_effect(6)
										
										gameState:add_powerup(index)
										gameState:remove_dots(price)
										gameState:save()								
										
										-- Update dots you have
										self:removeChild(self.text_dots)
										self:draw_title()
										
										--Update items you have
										local num = gameState.powerups[self.index]
										local number_items = self.number_items
										number_items:setText(num)
										local posX = (width - number_items:getWidth()) * 0.5
										number_items:setX(posX)
										
										local scene = self:getParent()
										if (scene.panel) then -- Redraw the powerup panel to update number of items
											scene:removeChild(scene.panel)
											scene.panel = nil
											
											PowerupScene.draw_panel(scene)
											scene.panel:setVisible(false)
										end
									elseif (gameState.dots < price) then -- Get dots in the shop scene
										
										SoundManager.play_effect(8)
										
										--[[
										local alertDialog = AlertDialog.new(getString("not_enough_dots"), 
																			getString("need_more"), 
																			getString("yes"), 
																			getString("no_thanks"))
										alertDialog:addEventListener(Event.COMPLETE, 
											function(event)
												if (event.buttonIndex) then
													sceneManager:changeScene(scenes[3], 1, SceneManager.fade, easing.linear)
												end
											end)
										]]--
										
										local alertDialog = AlertDialog.new(getString("not_enough_dots"), 
																			"",
																			getString("ok"))
										
										alertDialog:show()
									end
								end
							end)
end	

-- Draw OK button
function PowerupScene:draw_ok()
	local group = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, 0x5F9F9F)
	border:setLineStyle(2, Colors.BLACK)
	border:drawRoundRectangle(200, 80, 0)
	group:addChild(border)

	local text = TextField.new(MenuScene.font_button, getString("ok"))
	text:setTextColor(Colors.WHITE)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((200 - text:getWidth()) * 0.5, 30)
	group:addChild(text)
	
	group:setPosition(150, 590)
	self:addChild(group)
	
	group:addEventListener(Event.MOUSE_UP,
							function(event)
								if (group:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									
									SoundManager.play_effect(1)
									
									local scene = self:getParent()
									-- Check if game is paused or not
									if (scene and scene.show_paused) then
										PowerupScene.hide_powerup(scene)
										scene:show_paused()		
		
										Advertise.hideBanner()
									else
										sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
									end
								end
							end)
end

-- Static function to draw powerups panel
function PowerupScene.draw_panel(scene, show)
		
	if (scene) then	
		local panel = Sprite.new()
	
		local border = Shape.new()
		border:setFillStyle(Shape.SOLID, Colors.BLACK, 0.1)
		border:setLineStyle(2, Colors.BLACK)
		border:drawRoundRectangle(width-10, 140, 0)
		panel:addChild(border)
	
		border:setPosition(5, 630)
		scene:addChild(panel)
		scene.panel = panel
		
		local posX = {50, 200, 355}

		for a=1,3 do
			PowerupScene.draw_powerup(scene, posX[a], a, show)
		end
	end
end

-- Draw powerup icon
function PowerupScene.draw_powerup(scene, posX, a, show)

	if (scene and scene.panel) then
		local panel = scene.panel
		local powerups_num = gameState.powerups
	
		local scale = 0.6
		local scale_down = 0.5
		local posY = 650

		local texture
		if (powerups_num[a] > 0 or show) then
			texture = Hud.texture_powerup[a][1]
		else
			texture = Hud.texture_powerup[a][2]
		end
	
		local icon = Bitmap.new(texture)
		icon:setScale(scale)
		local icon2 = Bitmap.new(texture)
		if (powerups_num[a]) > 0 then
			icon2:setScale(scale_down)
		else
			icon2:setScale(scale)
		end
		
		local button = Button.new(icon, icon2)
		button:setPosition(posX, posY)
		panel:addChild(button)
		
		local number = TextField.new(PowerupScene.font_desc, powerups_num[a])
		local posX = button:getX() + (button:getWidth() - number:getWidth()) * 0.5
		number:setPosition(posX, posY + 80)
		number:setTextColor(0xffffff)
		number:setShadow(2,1, 0x000000)
		panel:addChild(number)
		
		button:addEventListener("click", function()
											if (scene.shop) then
												return
											end
		
											if (show) then
												SoundManager.play_effect(2)
												sceneManager:changeScene(scenes[5], 1, SceneManager.fade, easing.linear, {userData = a})
											else												
												if (scene.paused) then
													PowerupScene.show_powerup(scene, a)
												else
													local hud = scene.hud
													if (hud and hud.powerup_enabled[a]) then
														
														SoundManager.play_effect(7 + a)
														
														if (powerups_num[a] > 0) then
															powerups_num[a] = powerups_num[a] - 1
															number:setText(powerups_num[a])
															
															hud.powerup_used[a] = true -- Already used
															hud.powerup_enabled[a] = false
															
															scene:apply_powerup(a)
														
															local posX = button:getX() + (button:getWidth() - number:getWidth()) * 0.5
															number:setX(posX)
														
															texture = Hud.texture_powerup[a][2]
															icon:setTexture(texture)
															icon2:setTexture(texture)
														else													
															PowerupScene.show_powerup(scene, a)
														end
													end
												end
											end
										end)
	end
end

-- Show powerup scene over already existing game scene
function PowerupScene.show_powerup(scene, index)
	
	if (scene and scene.hide_layers) then
		scene:hide_layers()
		scene.paused = true
	
		local shop = PowerupScene.new(index)
		scene:addChild(shop)
		scene.shop = shop
	
		shop:enterEnd()
		
		-- Hide pause panel
		local caption = scene.caption
		if (caption and scene:contains(caption)) then
			scene:removeChild(caption)
		end
	end
end

-- Hide powerup scene
function PowerupScene.hide_powerup(scene)

	if (scene and scene.show_layers) then
		scene:removeChild(scene.shop)
		scene.shop = nil
		
		scene:show_layers()
	end
end

-- Go back to menu when back key is pressed
--[[
function PowerupScene:onKeyDown(event)
	local keyCode = event.keyCode
	if (keyCode == KeyCode.BACK) then
		
		event:stopPropagation()
		
		local parent = self:getParent()
		if (parent and parent:getChildIndex(self)) then
			parent:removeChild(self)
			parent.shop = nil
			
			--parent:show_paused()
		else
			-- Back to game mode scene
			--Timer.resumeAll()
			sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
		end
	end
end
]]--