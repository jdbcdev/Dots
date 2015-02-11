
application:setKeepAwake(true)
application:setOrientation(Application.PORTRAIT)

--require("mobdebug").start()

local android = application:getDeviceInfo() == "Android"
android = false

local width = application:getContentWidth()

local function draw_loading()
	loading = Sprite.new()
	
	local logo = Bitmap.new(Texture.new("gfx/jdbc_games.png", true))
	logo:setPosition((width - logo:getWidth()) * 0.5, 250)
	loading:addChild(logo)
	
	stage:addChild(loading)
end

-- Loading textures and sounds when game is starting
local function preloader()
	stage:removeEventListener(Event.ENTER_FRAME, preloader)
	
	Advertise.setup()
	MenuScene.setup()
	Hud.setup()
	ShopScene.setup()
	ScoreScene.setup()
	PowerupScene.setup()
	SoundManager.setup()
	
	Billing.setup()
	
	stage:removeChild(loading)
	loading = nil
	
	gameState = GameState.new()
	
	scenes = {"menu", "game", "shop", "score", "powerup", "modes"}
	sceneManager = SceneManager.new({
		["menu"] = MenuScene,
		["game"] = GameScene,
		["shop"] = ShopScene,
		["score"] = ScoreScene,
		["powerup"] = PowerupScene,
		["modes"] = GameModeScene
		})
	stage:addChild(sceneManager)
	sceneManager:changeScene(scenes[1])
end

draw_loading()
--stage:addEventListener(Event.ENTER_FRAME, preloader)

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