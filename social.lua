
local iOS = application:getDeviceInfo() == "iOS"
local android = application:getDeviceInfo() == "Android"

require "json"

-- Class with facebook logic
Social = Core.class()

local appName = "Squares"
local appId = "637816489595206" -- Jelly Sky

local fbPhotoQueue = {"100007175168061"}

-- Process photo queue
local function fbProcessPhoto()

	if #fbPhotoQueue > 0 then
		--get id
		local id = table.remove(fbPhotoQueue)
		
		--construct url
		local url = "https://graph.facebook.com/"..id.."/picture"
		print("url", url)
		
		--make UrlLoader call
		local loader = UrlLoader.new(url)
 
		loader:addEventListener(Event.COMPLETE, function(event)
			print("complete", id)
 
			-- try to save it in file as png
			local out = io.open("|D|"..id..".png", "wb")
			out:write(event.data)
			out:close()
 
			-- resave it as png, because image might have been jpeg
			--but media plugin will automatically convert it to png
			-- pcall because it might be other unsupported format
			pcall(function()
				local media = Media.new("|D|"..id..".png")
				media:save()
				media = nil
			end)
		end)
		
		-- we can ignore errors photos and try them again on next sync
		loader:addEventListener(Event.ERROR, function()
			print("error", id)
		end)
		
		--call to process next photo
		fbProcessPhoto()
	end
end

-- Check if file exists
function file_exists(name)
	local f = io.open(name,"r")
	if f~=nil then
		io.close(f)
		return true 
	else 
		return false 
	end
end

-- Load facebook user photo or default photo
function loadFBphoto(id)
	local texture
	
	if file_exists("|D|"..id..".png") then
	
		print("fichero existe")
		local success
		success, texture = pcall(Texture.new, "|D|"..id..".png", true)
		-- if I was able to load it (has correct format)
		if not success then
			texture = nil
		end
		
		print("success", success)
	end
	
	-- if no texture, take default pic
	if not texture then
		texture = Texture.new("gfx/speaker_blue.png", true)
	end
	
	return Bitmap.new(texture)
end

-- Constructor with current scene as parameter
function Social:init()
	
	if (iOS or android) then
		require "facebook"
	else
		return
	end
	
	self.error = false	
	
	-- Event listeners
	facebook:addEventListener(Event.LOGIN_COMPLETE, self.onLoginComplete, self)
	facebook:addEventListener(Event.LOGIN_ERROR, self.onLoginError, self)
	facebook:addEventListener(Event.LOGOUT_COMPLETE, function() print("logout") end)
	
	facebook:addEventListener(Event.DIALOG_COMPLETE, 
								function(event) 
									print("dialog complete")
									--local response = json.decode(event)
									--for k,v in pairs(event) do
										--print(k,v)
									--end
								end)
	facebook:addEventListener(Event.DIALOG_ERROR, function(event) print("dialog error: ", event.errorCode, event.errorDescription) end)
	
	--[[
	facebook:addEventListener(Event.REQUEST_COMPLETE, 
								function(event)
									print(event.response)
									facebook.lastResponse = json.decode(event.response)
									
									if (facebook.lastResponse) then
										local response = facebook.lastResponse
										if(response == true) then
											print("Request send score")
											--Request user info
										elseif (response.id) then
											--print("Request user info ", response.name, response.id, response.gender)
											--User info in -->facebook.lastResponse
											self.userId = response.id
											self.name = response.name
											self:getScores()
										elseif(response.error) then
											print("Error "..facebook.lastResponse.error.message)
										elseif (response.data and #response.data > 0) then
											-- Loading score of friends
											local data = response.data
											self.scene = sceneManager:getCurrentScene()
											local currentScene = self.scene
											if (data[1].user) then 
												-- Score list
												print("Score list")
												self.score_list = data
												if (currentScene and currentScene.draw_list) then
													currentScene:draw_list()
												end
												
											elseif (data[1].name) then
												-- Friends list
												print("Friends list")
												self.friends_list = data
											end
											--Scores in --> facebook.lastResponse
										end
									end
								end)]]--
								
	facebook:addEventListener(Event.REQUEST_COMPLETE,
								function(event)
									print("request complete", event.type, event.response)
									
									local response = json.decode(event.response)
									if (event.type == "me") then
										--User info
										self.userid = response.id
										self.first_name = response.first_name
										self.name = response.name
										self.gender = response.gender
									elseif (event.type =="me/picture") then
										-- User picture
										print("User picture")
									end
								end)
	facebook:addEventListener(Event.REQUEST_ERROR, function(event) print("request error", event.errorCode, event.errorDescription) end)
	
end

-- Login complete callback
function Social:onLoginComplete(event)
	print("Login complete")
	
	self.error = false
	
	-- The following methods are only executed once
	self.accessToken = facebook:getAccessToken()
	print("Access token", self.accessToken)
	
	--self:getUserInfo()
	--self:getFriends()
	
	--self:getScores()
	
	local scene = sceneManager:getCurrentScene()
	if (scene and scene.loginResponse) then
		scene:loginResponse()
		self.scene = scene
	end
end

-- Login error callback
function Social:onLoginError(event)
	print("login error")
													
	self.error = true
	
	local scene = sceneManager:getCurrentScene()
	if (scene and scene.loginError) then
		scene:loginError()
	end
end

-- Return true if is already connected
function Social:isConnected()
	local access_token = facebook:getAccessToken()
	local result = not (access_token == "")
	
	return result
end

-- Facebook login
function Social:login()
	if (not self:isConnected()) then
		facebook:login(appId, {"basic_info", "publish_actions"}) --, {"publish_actions"})
	end
end

-- Facebook logout
function Social:logout()
	
	if (self:isConnected()) then
		facebook:logout()
	end
end

function Social:getAccessToken()
	self.accessToken = facebook:getAccessToken()
end

-- Get user info
function Social:getUserInfo()
	
	if (self:isConnected()) then
		facebook:getProfile()
	end
end

-- Retrieve access token expiration date
function Social:getExpirationDate()
	self.expirationDate = facebook:getExpirationDate()
end

-- Send score to Facebook
function Social:sendScore(score)

	if (self:isConnected()) then
		print("Send score to facebook "..score)
		local parameters = {
			score = score,
			--fields = "firstname"	
		}
		facebook:postScore(parameters)
	end
end

--Invite some friends to play the game. Open request dialog and select friends to invite
function Social:inviteFriends(message)
	
	if (self:isConnected()) then
	
		message = message or "Check out this awesome game"
	
		local params = {
			title = appName.." request",
			message = message
		}
	
		facebook:dialog("apprequests", params)
	end
end

-- Read score for a player id
function Social:readScore(playerId)
	
	if (self:isConnected()) then
		if not playerId then
			playerId = "me"
		end
	
		facebook:get(playerId.."/scores")
	end
end

-- Read scores for players and friends (https://developers.facebook.com/docs/games/scores/)
function Social:getScores()
	if (self:isConnected()) then
		facebook:get(appId.."/scores")
	end
end

-- Share a post on Wall
function Social:feed(userId)

	if (self:isConnected()) then
		local params = {
			name = "Facebook for Android",
			caption = "Build great social apps and get more installs.",
			description = "The Facebook SDK for Android makes it easier and faster to develop Facebook integrated Android apps.",
			link = "http://giderosmobile.com", 
			picture = "http://www.giderosmobile.com/wp-content/uploads/2012/06/gideros-mobile-small.png"
		}
 
		if (userId) then
			params.to = userId
		end
	
		facebook:dialog("feed", params)
	end
end

-- Send request to userId
function Social:invite(userId)
	
	if (self:isConnected()) then
		local params = {
			title = "Jelly Sky request",
			message = "Check out this awesome app",
			to = userId
		}
		facebook:dialog("apprequests", params)
	end
end

-- Get friends list
function Social:getFriends()
	if (self:isConnected()) then
		facebook:getFriends()
	end
end

-- Get pending request (invitation notification)
function Social:getRequest()

	if (self:isConnected()) then
		facebook:graphRequest("me/requests")
	end
end

-- Retrieve user picture
function Social:getUserPicture(userId)
	
	fbProcessPhoto()
	
	--[[
	local photo = loadFBphoto("100007175168061")
	if (photo) then
		photo:setPosition(50, 300)
		stage:addChild(photo)
	end
	]]--
	
	--[[
	if (userId) then
		facebook:get("/"..userId.."/picture",{type="small"})
	else
		facebook:get("me/picture",{type="small"})
	end
	]]--
end