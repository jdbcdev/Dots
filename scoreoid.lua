
Scoreoid = Core.class()

local API_KEY = "6bfe7feb6b114402bd5ec27dd13f69246518c319"
local GAME_ID = "79de54118d"
local platform = application:getDeviceInfo()

local headers = {
					["Authorization"] = "Basic",
					["Content-Type"]  = "application/json"
					--["Content-Type"]  = "application/x-www-form-urlencoded"
					}

-- Create a new player
function Scoreoid.createPlayer()

	local username = "fb_userid"
	local method = UrlLoader.POST
	--local body = "api_key="..API_KEY.."&game_id="..GAME_ID.."&username="..username.."&score=120&response=JSON"
	
	local data = {
					api_key = API_KEY,
					game_id = GAME_ID,
					username = username,
					platform = platform,
					response = 'JSON'
					}
	local body = json.encode(data)
	local url = "https://api.scoreoid.com/v1/createPlayer"
	
	
	local loader = UrlLoader.new(url, method, headers, body)
 
	local function onComplete(event)
		print("onComplete", event.data)
	end
 
	local function onError()
		print("onError")
	end
 
	local function onProgress(event)
		print("onProgress: ")
	end
 
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end

-- Get player info
function Scoreoid.getPlayer()

	local username = "fb_userid"
	local method = UrlLoader.POST
	--local body = "api_key="..API_KEY.."&game_id="..GAME_ID.."&username="..username.."&score=120&response=JSON"
	
	local data = {
					api_key = API_KEY,
					game_id = GAME_ID,
					username = username,
					--platform = platform,
					response = 'JSON'
					}
	local body = json.encode(data)
	local url = "https://api.scoreoid.com/v1/getPlayer"
	
	local loader = UrlLoader.new(url, method, headers, body)
 
	local function onComplete(event)
		print("onComplete", event.data)
	end
 
	local function onError()
		print("onError")
	end
 
	local function onProgress(event)
		print("onProgress: ")
	end
 
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end


-- Create a score for a player
--
-- Post parameters
--
-- api_key=> Your API Key [Required]
-- game_id => Your Game ID [Required]
-- response => String Value, "XML" or "JSON" [Required]
-- username => String Value, if user does not exist it well be created [Required]
-- score => Integer Value, [Required]
-- platform => String Value, [Optional]
-- unique_id => Integer Value, [Optional]
-- difficulty => Integer Value (don't use 0 as it's the default value) [Optional]
-- data => Custom Data Value, [Optional]
--
function Scoreoid.createScore(username, level, score )
	
	local method = UrlLoader.POST
	
	local data = {
					api_key = API_KEY,
					game_id = GAME_ID,
					username = username,
					score = 230,
					difficulty = 2, -- LEVEL
					platform = platform,
					response = 'JSON'
					}
	local body = json.encode(data)
	--local body = "api_key="..API_KEY.."&game_id="..GAME_ID.."&username="..username.."&score=100".."&platorm="..platform.."&response=JSON"
	local url = "https://api.scoreoid.com/v1/createScore"
 
	local loader = UrlLoader.new(url, method, headers, body)
 
	local function onComplete(event)
		print("onComplete", event.data)
	end
 
	local function onError()
		print("onError")
	end
 
	local function onProgress(event)
		print("onProgress")
	end
 
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end

-- Get best score for given username
function Scoreoid.getBestScore(username, level)
	local method = UrlLoader.POST
	
	local data = {
					api_key = API_KEY,
					game_id = GAME_ID,
					username = username,
					score = 230,
					difficulty = level, -- LEVEL
					platform = platform,
					response = 'JSON'
					}
	local body = json.encode(data)
	--local body = "api_key="..API_KEY.."&game_id="..GAME_ID.."&username="..username.."&score=100".."&platorm="..platform.."&response=JSON"
	local url = "https://api.scoreoid.com/v1/getBestScores"
 
	local loader = UrlLoader.new(url, method, headers, body)
 
	local function onComplete(event)
		print("onComplete", event.data)
	end
 
	local function onError()
		print("onError")
	end
 
	local function onProgress(event)
		print("onProgress")
	end
 
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end

-- Increase score
function Scoreoid.increaseScore()
	
	local username = "fb_userid"
	local method = UrlLoader.POST
	
	local data = {
					api_key = API_KEY,
					game_id = GAME_ID,
					username = username,
					score = 240,
					difficulty = 2, -- LEVEL
					platform = platform,
					response = 'JSON'
					}
	local body = json.encode(data)
	
	--local body = "api_key="..API_KEY.."&game_id="..GAME_ID.."&username="..username.."&score=100&response=JSON"
	local url = "https://api.scoreoid.com/v1/incrementScore"
 
	local loader = UrlLoader.new(url, method, headers, body)
 
	local function onComplete(event)
		print("onComplete", event.data)
	end
 
	local function onError()
		print("onError")
	end
 
	local function onProgress(event)
		print("onProgress")
	end
 
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end

