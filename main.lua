
application:setKeepAwake(true)
application:setOrientation(Application.PORTRAIT)

--require("mobdebug").start()


local width = application:getContentWidth()

local function draw_loading()
	loading = Sprite.new()
	
	local logo = Bitmap.new(Texture.new("gfx/jdbc_games.png", true))
	--logo:setScale(0.67)
	logo:setPosition((width - logo:getWidth()) * 0.5, 200)
	loading:addChild(logo)
	
	--local tween = GTween.new(logo, 2, {y=200}, {ease = easing.outElastic})
	
	local font =  TTFont.new("fonts/new_academy.ttf", 50)
	local text = TextField.new(font, "Loading")
	text:setTextColor(0xff0000)
	text:setShadow(2, 1, 0x000000)
	local posX = (width - text:getWidth()) * 0.5
	text:setPosition(posX, 500)
	loading.text = text
	loading:addChild(text)
	
	stage:addChild(loading)
end

-- Loading textures and sounds when game is starting
local function preloader()
	stage:removeEventListener(Event.ENTER_FRAME, preloader)
	
	--Advertise.setup()
	MenuScene.setup()
	Hud.setup()
	--GameScene.setup()
	
	stage:removeChild(loading)
	loading = nil
	
	scenes = {"menu", "game"} --, "score"}
	sceneManager = SceneManager.new({
		["menu"] = MenuScene,
		["game"] = GameScene,
		--["score"] = ScoreScene
		})
	stage:addChild(sceneManager)
	sceneManager:changeScene(scenes[1])
end

draw_loading()
stage:addEventListener(Event.ENTER_FRAME, preloader)

Submit.get_scores() 
--Submit.add_score(1, 100)

local transitions = {
	SceneManager.moveFromLeft,
	SceneManager.moveFromRight,
	SceneManager.moveFromBottom,
	SceneManager.moveFromTop,
	SceneManager.moveFromLeftWithFade,
	SceneManager.moveFromRightWithFade,
	SceneManager.moveFromBottomWithFade,
	SceneManager.moveFromTopWithFade,
	SceneManager.overFromLeft,
	SceneManager.overFromRight,
	SceneManager.overFromBottom,
	SceneManager.overFromTop,
	SceneManager.overFromLeftWithFade,
	SceneManager.overFromRightWithFade,
	SceneManager.overFromBottomWithFade,
	SceneManager.overFromTopWithFade,
	SceneManager.fade,
	SceneManager.crossFade,
	SceneManager.flip,
	SceneManager.flipWithFade,
	SceneManager.flipWithShade}

--local scene = GameScene.new()
--stage:addChild(scene)
