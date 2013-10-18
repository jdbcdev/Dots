
Hud = Core.class(Sprite)

local font = TTFont.new("fonts/ComicBookCommando.ttf", 40)

Hud.SCORE_FORMAT = "%08d"

-- Constructor
function Hud:init()
	
	self.score = 0
	self.moves = 0
	
	self:draw_background()
	
	local formated_score = string.format(self.score, Hud.SCORE_FORMAT)
	local text_score = TextField.new(font, "Score:")
	text_score:setPosition(30, 40)
	self.text_score = text_score
	self:addChild(text_score)
	
	local text_score2 = TextField.new(font, self.score)
	text_score2:setPosition(text_score:getWidth() + 38, 40)
	self.text_score2 = text_score2
	self:addChild(text_score2)
	
	local text_moves = TextField.new(font, "Moves:")
	text_moves:setPosition(application:getContentWidth() * 0.5 + 20, 40)
	self.text_moves = text_moves
	self:addChild(text_moves)
	
	local text_moves2 = TextField.new(font, self.moves)
	text_moves2:setPosition(application:getContentWidth() * 0.5 + text_moves:getWidth() + 30, 40)
	self.text_moves2 = text_moves2
	self:addChild(text_moves2)
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

-- Increase score +1
function Hud:updateScore(list)
	
	local score = self.score
	for i=1, #list do
		score = score + 1
	end
	
	self.score = score
	self.text_score2:setText(self.score)
end

-- One more movement
function Hud:updateMoves()
	self.moves = self.moves + 1
	self.text_moves2:setText(self.moves)
end