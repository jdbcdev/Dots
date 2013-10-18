
Dot = Core.class(Sprite)

local textures_types = {
						Texture.new("gfx/circle_yellow.png", true),
						Texture.new("gfx/circle_red.png", true),
						Texture.new("gfx/circle_orange.png", true),
						Texture.new("gfx/circle_green.png", true),
						Texture.new("gfx/circle_blue.png", true),
						Texture.new("gfx/circle_grey.png", true)
						}

-- Constructor
function Dot:init()
	local dot_type = math.random(5)
	local dot = Bitmap.new(textures_types[dot_type])
	self.enabled = true
	self.type = dot_type
	self.row = i
	self.col = j
	self:setScale(0.43)
	self:addChild(dot)
end