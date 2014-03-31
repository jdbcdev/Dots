
Submit = Core.class()

-- Local functions
local function onComplete(event)
	--local data = json.decode(event.data)
	print("onComplete", data)
	
	if (data) then
		local a
		for a=1, #data do
			print(a, data[a])
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
-- Testing: curl -i -X POST -H 'Content-Type: application/json' -d '{"level": 1, "points": 100}' http://localhost:3000/scores 
function Submit.add_score(level, points)

	level = level or 1
	
	local method = UrlLoader.POST
	local headers = {
		--["Authorization"] = "Basic",
		["Content-Type"]  = "application/json"
	}
	
	local data = {level = level,
				  points = points}
				  
	local body = json.encode(data)
	print("body", body)
	
	local loader = UrlLoader.new("http://localhost:3000/scores", method, headers, body)
	
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end

function Submit.update_score(level, points)
	level = level or 1
	
	local method = UrlLoader.PUT
	local headers = {
		["Authorization"] = "Basic",
		["Content-Type"]  = "application/json"
	}
	
	local loader = UrlLoader.new("http://localhost:3000/scores/"..level, method, headers, body)
	
	loader:addEventListener(Event.COMPLETE, onComplete)
	loader:addEventListener(Event.ERROR, onError)
	loader:addEventListener(Event.PROGRESS, onProgress)
end