
ParseAPI = Core.class()

local base_url = "https://api.parse.com"
local headers = {
					["X-Parse-Application-Id"] = "LxAE3MSSKjilcB8JbvX2SMYybpg2uXExEeKBHmtC",
					["X-Parse-REST-API-Key"] = "RSmixm8q6jFswCpQYyB58qZOO0UcJCouJ0ZY215I",
					["Content-Type"]  = "application/json"
					}

require "json"

-- Convert date to format "2014-06-01T15:06:46.000Z"
local function convertDate(string_date)

	local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
	local year, month, day, hour, minute, sec = string_date:match(pattern)
	
	local converted	= os.time( {year = year, 
								month = month, 
								day = day, 
								hour = hour, 
								min = minute, 
								sec = sec}
								)
	
	local formated_date = os.date("!%Y-%m-%dT%H:%m:%S.000Z", converted)
	
	return formated_date
end

-- Parse login using authData
function ParseAPI.login()
	local url = base_url.."/1/users"
	local method = UrlLoader.POST
	
	print("social.userid", social.userid)
	
	local data = {}
	local authData = {}
	local token = {
					id = social.userid,
					access_token = social.accessToken,
					expiration_date = convertDate(social.expirationDate)
					}
	
	authData.facebook = token
	data.authData = authData
	local body = json.encode(data)
	
	--print("body", body)
	
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

-- Retrieve current user and validate session token
function ParseAPI.getUserInfo()
	local url = base_url.."/1/users/me"
	local method = UrlLoader.GET
	
	
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

-- Create a new object on Parse (https://www.parse.com/docs/rest#objects-classes)
function ParseAPI.createObject(className, object)

	object = {}
	object.userid = social.userid
	object.state = {}
	object.state[1] = {} -- Episode 1
	--object.state[1][1] = {}
	local state = {score = 650, num_stars = 1, completed = true}
	object.state[1][1] = state
	
	if (className and object) then
		local url = base_url.."/1/classes/"..className
		local method = UrlLoader.POST
		
		local body = json.encode(object)
		print("body", body)
		
		local loader = UrlLoader.new(url, method, headers, body)
 
		local function onComplete(event)
			print("onComplete", event.data)
			
			local response = json.decode(event.data)
			local objectId = response.objectId
			dataSaver.saveValue(className, objectId)
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
	else
		print("Error: class name or object is nil")
	end
end

-- Update object on Parse
function ParseAPI.updateObject(className, object)
	
	local objectId = dataSaver.loadValue(className) -- Previosly stored on disk
	if (objectId and className and object) then
		local url = base_url.."/1/classes/"..className.."/"..objectId
		local method = UrlLoader.PUT
		
		local body = json.encode(object)
		
		--print("url", url)
		--print("body", body)
		
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
end

-- Retrieve all objects
function ParseAPI.getAllObjects(class_name)
	local url = base_url.."/1/classes/"..className
	local method = UrlLoader.GET
	
	local loader = UrlLoader.new(url, method, headers)
 
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

-- Retrieve a list of all users
function ParseAPI.getAllUsers()
	local url = base_url.."/1/users"
	local method = UrlLoader.GET
	
	local loader = UrlLoader.new(url, method, headers)
 
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