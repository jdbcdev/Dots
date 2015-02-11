
application:setKeepAwake(true)
application:setOrientation(Application.PORTRAIT)

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
	LeaderBoardScene.setup()
	
	stage:removeChild(loading)
	loading = nil
	
	gameState = GameState.new()
	
	scenes = {"menu", "game", "shop", "score", "powerup", "modes", "leaderboard"}
	sceneManager = SceneManager.new({
		["menu"] = MenuScene,
		["game"] = GameScene,
		["shop"] = ShopScene,
		["score"] = ScoreScene,
		["powerup"] = PowerupScene,
		["modes"] = GameModeScene,
		["leaderboard"] = LeaderBoardScene
		})
	stage:addChild(sceneManager)
	sceneManager:changeScene(scenes[7])
end

draw_loading()
stage:addEventListener(Event.ENTER_FRAME, preloader)
