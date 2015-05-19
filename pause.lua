
-- This class describes a message window or popup

Caption = Core.class(Sprite)

local width = application:getContentWidth()
local height = application:getContentHeight()

-- Constructor
function Caption:init(scene)
	
	self.scene = scene
	
	self:draw_window()
	self:draw_paused()
	self:draw_buttons()
	
	self:draw_comment()
end

-- Show interstitial ads
function Caption:show_ads()

	local ad_type = math.random(1,2)
	if (ad_type == 1) then
		Advertise.showInterstitial()
	end
end

-- Draw window
function Caption:draw_window()
	
	local color = 0xC1CDC1
	
	local mesh = self.mesh
	mesh = Mesh.new()
	mesh:setVertices(1, 0, 70, 2, width, 70, 3, width, height - 200, 4, 0, height - 200)
	mesh:setIndexArray(1, 2, 3, 1, 3, 4)
	mesh:setColorArray(color, 0.9, color, 0.9, color, 0.9, color, 0.9)
	self:addChild(mesh)
end

-- Draw "Paused" text
function Caption:draw_paused()

	local text = TextField.new(MenuScene.font_title, getString("paused"))
	text:setTextColor(Colors.YELLOW)
	text:setShadow(2, 1, 0x000000)
	local posX = (width - text:getWidth()) * 0.5
	text:setPosition(posX, 160)
	self:addChild(text)
end

-- Draw resume and main menu buttons
function Caption:draw_buttons()
	
	local scene = self.scene
	
	-- Resume button
	local button_resume = self:draw_option("resume", 260, 0x5F9F9F)
	button_resume:addEventListener(Event.MOUSE_UP, 
								function(event)
									if (scene.paused and button_resume:hitTestPoint(event.x, event.y)) then
										event:stopPropagation()
										SoundManager.play_effect(5)
										scene:hide_paused()
									end
								end
							)
	self:addChild(button_resume)

	local button_home = self:draw_option("main_menu", 450, 0xB9D3EE)
	button_home:addEventListener(Event.MOUSE_UP,
							function(event)
								if (scene.paused and button_home:hitTestPoint(event.x, event.y)) then
									event:stopPropagation()
									SoundManager.play_effect(2)
									Timer.resumeAll()
									sceneManager:changeScene(scenes[6], 1, SceneManager.fade, easing.linear)
								end
							end
						)
	self:addChild(button_home)
end

-- Draw one option
function Caption:draw_option(label, posY, color)
	local button_resume = Sprite.new()
	
	local border = Shape.new()
	border:setFillStyle(Shape.SOLID, color)
	border:setLineStyle(2, 0xF0FFF0)
	border:drawRoundRectangle(300, 100, 40)
	button_resume:addChild(border)

	local text = TextField.new(MenuScene.font_button, getString(label))
	text:setTextColor(0xFFD700)
	text:setShadow(3, 1, 0x000000)
	text:setPosition((300 - text:getWidth()) * 0.5, 40)
	button_resume:addChild(text)
	
	button_resume:setPosition(100, posY)
	self:addChild(button_resume)
	
	return button_resume
end

-- Draw Add powerup comment
function Caption:draw_comment()

	local text = TextField.new(MenuScene.font_button, getString("add_powerup"))
	text:setTextColor(0x1C86EE)
	text:setShadow(2, 1, 0x000000)
	local posX = (width - text:getWidth()) * 0.5
	text:setPosition(posX, 610)
	self:addChild(text)
end

