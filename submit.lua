
Submit = Core.class()

-- Local functions
local function onComplete(event)
	--local data = json.decode(event.data)
	print("onComplete", event.data)
	
	if (event and event.data) then
		local list = json.decode(event.data)
		
		if (list) then
			local a
			for a=1, #list do
				local data = list[a]
				print(a, data.userid)
				local b 
				for b=1, #data.points do
					print(data.points[b])
				end
			end
		end
	end
end

local function onError()
	print("onError")
end

local function onProgress(event)
	print("onProgress")
end

-- Get score list from server (HTTP GET Request)
-- Testing: curl -i -X GET http://localhost:3000/scores 
function Submit.get_scores()
	local loader = UrlLoader.new("http://localhost:3000/scores") -- TODO Change with Heroku URL
	
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end

-- Send level score to server (HTTP POST Request)
-- Testing: curl -i -X POST -H 'Content-Type: application/json' -d '{"userid": "12345678", "points": [100, 50]}' http://localhost:3000/scores 
function Submit.add_score(level, points)

	level = level or 1
	
	local method = UrlLoader.POST
	local headers = {
		["Authorization"] = "Basic",
		["Content-Type"]  = "application/json"
	}
	
	--[[
	local data = {level = level,
				  points = points}
	]]--
	
	local data = {
				  userid = "123456789", -- TODO Use Facebook user id
				  --level = 1,
				  points = {100, 50}
				  }
				  
	local body = json.encode(data)
	--print("body", body)
	
	local loader = UrlLoader.new("http://localhost:3000/scores", method, headers, body)
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end

-- Update score to server (HTTP PUT Request)
-- Testing: curl -i -X PUT -H 'Content-Type: application/json' -d '{"level": 1, "points": [100, 200]}' http://localhost:3000/wines/5069b47aa892630aae000007 
function Submit.update_score(id, level, points)
	level = level or 1
	
	local method = UrlLoader.PUT
	local headers = {
		["Authorization"] = "Basic",
		["Content-Type"]  = "application/json"
	}
	
	--[[
	local data = {
					"level" = 1
					--"points" = points
					}
	]]--
	
	local data = {
				  userid = "123456789", -- TODO Use Facebook user id
				  --level = 1,
				  points = points
				  }
	local body = json.encode(data)
	
	local url = "http://localhost:3000/scores/"..id
	local loader = UrlLoader.new(url, method, headers, body)
	
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end
