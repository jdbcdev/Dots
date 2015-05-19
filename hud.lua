
Hud = Core.class(Sprite)

local width = application:getContentWidth()

local font_title = TTFont.new("fonts/new_academy.ttf", 28)
local font_data = TTFont.new("fonts/new_academy.ttf", 36)

function Hud.setup()
		
	local texture_powerup = {}
	texture_powerup[1] = {
							Texture.new("gfx/gear_red.png", true),
							Texture.new("gfx/gear_grey.png", true)
						 }
	texture_powerup[2] = {
							Texture.new("gfx/trash_yellow.png", true),
							Texture.new("gfx/trash_grey.png", true)
						 }
	texture_powerup[3] = {
							Texture.new("gfx/hyperlink_green.png", true),
							Texture.new("gfx/hyperlink_grey.png", true)
							}
	Hud.texture_powerup = texture_powerup
end

-- Constructor
function Hud:init(scene)
	
	self.scene = scene
	scene:addChild(self)
	
	self.score = 0
	self.moves = 25 -- 25 + extra moves based on player progress
	self.powerup_enabled = { true, true, true }
	
	self:draw_background()
	
	local posY = 26
	local text_score = TextField.new(font_title, "Score:")
	text_score:setPosition(30, posY)
	self.text_score = text_score
	self:addChild(text_score)
	
	local text_score2 = TextField.new(font_data, self.score)
	text_score2:setTextColor(Colors.WHITE)
	text_score2:setShadow(2, 1, Colors.BLACK)
	text_score2:setPosition(text_score:getWidth() + 38, posY - 4)
	self.text_score2 = text_score2
	self:addChild(text_score2)
	
	local text_moves = TextField.new(font_title, "Moves:")
	text_moves:setPosition(width * 0.5 + 40, posY)
	self.text_moves = text_moves
	self:addChild(text_moves)
	
	local text_moves2 = TextField.new(font_data, self.moves)
	text_moves2:setTextColor(Colors.WHITE)
	text_moves2:setShadow(2, 1, Colors.BLACK)
	text_moves2:setPosition(width * 0.5 + text_moves:getWidth() + 50, posY -4)
	self.text_moves2 = text_moves2
	self:addChild(text_moves2)
	
	self:draw_powerups()
end

-- Draw the rectangle background
function Hud:draw_background()
	local initial_y = 0
	
	local mesh = Mesh.new()
	mesh:setVertices(1, 0, initial_y, 2, width, initial_y, 3, width, initial_y + 60, 4, 0, initial_y + 60)
	mesh:setIndexArray(1, 2, 3, 1, 3, 4)
	mesh:setColorArray(0xB9D3EE, 0.92, 0xB9D3EE, 0.92, 0xB9D3CC, 0.92, 0xB9D3CC, 0.9)
	self:addChild(mesh)
end

-- Draw powerups panel
function Hud:draw_powerups()
	
	PowerupScene.draw_panel(self.scene)
end

-- Increase score (+1 normal)
function Hud:updateScore(list)
	
	local scene = self.scene
	local score = self.score
	local bonus = 1
	
	local dot = list[#list]
	
	if (#list >= 7) then
		bonus = 3 -- Bonus x3
		scene:showBonus(bonus, dot:getX(), dot:getY())
	elseif (#list > 3) then
		bonus = 2 -- Bonus x2
		scene:showBonus(bonus, dot:getX(), dot:getY())
	end
	
	for i=1, #list do
		score = score + bonus
	end
	
	self.score = score
	self.text_score2:setText(self.score)
end

-- One move done
function Hud:updateMoves()

	if (self.moves > 1) then
		self.moves = self.moves - 1
		self.text_moves2:setText(self.moves)
	else
		gameState:add_dots(self.score)
		gameState:save()
		
		sceneManager:changeScene(scenes[4], 1, SceneManager.fade, easing.linear, {userData = self.score})
	end
end

-- Five movements extra
function Hud:addMoves()	
	self.moves = self.moves + 5
	self.text_moves2:setText(self.moves)
end