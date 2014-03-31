
Hud = Core.class(Sprite)

local font_title = TTFont.new("fonts/new_academy.ttf", 28)
local font_data = TTFont.new("fonts/new_academy.ttf", 36)

Hud.SCORE_FORMAT = "%08d"

function Hud.setup()
	Hud.texture_clock = Texture.new("gfx/clock.png", true)
	Hud.texture_trash = Texture.new("gfx/trash_yellow.png", true)
	Hud.texture_expander = Texture.new("gfx/speaker_blue.png", true)
end

-- Constructor
function Hud:init()
	
	self.score = 0
	self.moves = 30
	
	self:draw_background()
	
	local posY = 26
	local formated_score = string.format(self.score, Hud.SCORE_FORMAT)
	local text_score = TextField.new(font_title, "Score:")
	text_score:setPosition(30, posY)
	self.text_score = text_score
	self:addChild(text_score)
	
	local text_score2 = TextField.new(font_data, self.score)
	text_score2:setPosition(text_score:getWidth() + 38, posY - 4)
	self.text_score2 = text_score2
	self:addChild(text_score2)
	
	local text_moves = TextField.new(font_title, "Moves:")
	text_moves:setPosition(application:getContentWidth() * 0.5 + 40, posY)
	self.text_moves = text_moves
	self:addChild(text_moves)
	
	local text_moves2 = TextField.new(font_data, self.moves)
	text_moves2:setPosition(application:getContentWidth() * 0.5 + text_moves:getWidth() + 50, posY -4)
	self.text_moves2 = text_moves2
	self:addChild(text_moves2)
	
	self:draw_powerups()
end

-- Draw the rectangle background
function Hud:draw_background()
	local initial_y = 0
	local width = application:getContentWidth()
	local mesh = Mesh.new()
	mesh:setVertices(1, 0, initial_y, 2, width, initial_y, 3, width, initial_y + 60, 4, 0, initial_y + 60)
	mesh:setIndexArray(1, 2, 3, 1, 3, 4)
	mesh:setColorArray(0xC6E2FF, 0.92, 0xC6E2CC, 0.92, 0xcccccc, 0.92, 0xcccccc, 0.9)
	self:addChild(mesh)
end

-- Draw power-up buttons
function Hud:draw_powerups()

	local posY = 680
	local scale = 0.6
	local scale_down = 0.7
	
	-- Clock
	local icon_clock = Bitmap.new(Hud.texture_clock)
	icon_clock:setScale(scale)
	local icon_clock2 = Bitmap.new(Hud.texture_clock)
	icon_clock2:setScale(scale_down)
	local clock = Button.new(icon_clock, icon_clock2)
	clock:setPosition(50, posY)
	self:addChild(clock)
	
	clock:addEventListener("click", function()
										print("stop clock")
									end)
	
	-- Trash
	local icon_shrinker = Bitmap.new(Hud.texture_trash)
	icon_shrinker:setScale(scale)
	local icon_shrinker2 = Bitmap.new(Hud.texture_trash)
	icon_shrinker2:setScale(scale_down)
	local shrinker = Button.new(icon_shrinker, icon_shrinker2)
	shrinker:setPosition(200, posY)
	self:addChild(shrinker)
	
	shrinker:addEventListener("click", function()
											print("remove squares same color")
										end)
	
	-- Remove same color
	local icon_expander = Bitmap.new(Hud.texture_expander)
	icon_expander:setScale(scale)
	local icon_expander2 = Bitmap.new(Hud.texture_expander)
	icon_expander2:setScale(scale_down)
	local expander = Button.new(icon_expander, icon_expander2)
	expander:setPosition(350, posY)
	self:addChild(expander)
	
	expander:addEventListener("click", function()
											print("remove one square")
										end)
end

-- Increase score +1
function Hud:updateScore(list)
	
	local score = self.score
	for i=1, #list do
		score = score + 1
	end
	
	self.score = score
	self.text_score2:setText(self.score)
end

-- One move more
function Hud:updateMoves()
	self.moves = self.moves + 1
	self.text_moves2:setText(self.moves)
end
