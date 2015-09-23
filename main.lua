
application:setKeepAwake(true)
application:setOrientation(Application.PORTRAIT)

local iOS = application:getDeviceInfo() == "iOS"
local android = application:getDeviceInfo() == "Android"

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
	
	if (iOS or android) then
		social = Social.new()
		
		--social:logout()
		
		-- Automatic login
		if (social:wasConnected()) then
			social:login()
		end
	end
	
	Advertise.setup()
	MenuScene.setup()
	Hud.setup()
	ShopScene.setup()
	ScoreScene.setup()
	PowerupScene.setup()
	SoundManager.setup()
	
	--Billing.setup()
	LeaderBoardScene.setup()
	
	--stage:removeChild(loading)
	--loading = nil
	
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
	
	local timer = Timer.new(1000, 1)
	timer:addEventListener(Event.TIMER, 
				function()
					-- Remove loading scene
					stage:removeChild(loading)
					loading = nil
					sceneManager:changeScene(scenes[1])
				end)
	timer:start()
end

draw_loading()
stage:addEventListener(Event.ENTER_FRAME, preloader)
