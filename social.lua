
local iOS = application:getDeviceInfo() == "iOS"
local android = application:getDeviceInfo() == "Android"

require "json"
--require "media"

-- Class with facebook logic
Social = Core.class()

local appName = "Square Dots"
local appId = "801512953264015" -- Square Dots Facebook

local fbPhotoQueue = {}

-- Process photo queue
local function fbProcessPhoto()

	if #fbPhotoQueue > 0 then
		local id = table.remove(fbPhotoQueue) -- Facebook userid
		
		print("PROCESSING PHOTO", id)
		
		--construct url
		local url = "https://graph.facebook.com/"..id.."/picture"
		--print("url", url)
		
		--make UrlLoader call
		local loader = UrlLoader.new(url)
 
		loader:addEventListener(Event.COMPLETE, function(event)
			--print("complete", id)
 
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

-- Create Singleton instance
function Social.getInstance()
	
	if (android or iOS) then
		if (not social) then
			social = Social.new()
		end
	end
end

-- Constructor with current scene as parameter
function Social:init()
		
	if (iOS or android) then
		require "facebook"
	else
		return
	end
	
	self.connected = false
	self.error = false
	self.session_token = dataSaver.loadValue("sessionToken")
	
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
									
	facebook:addEventListener(Event.REQUEST_COMPLETE,
								function(event)
									print("request complete", event.type, event.response)
							
									local response = json.decode(event.response)
									local type = event.type
									if (type == "me") then
										--User info
										self.userid = response.id
										self.first_name = response.first_name
										self.name = response.name
										self.gender = response.gender
										
										table.insert(fbPhotoQueue, self.userid)
										fbProcessPhoto() -- Get user photo
										
										self:getFriends()
										
										-- Link with Parse
										--[[
										if (social.userid) then
											ParseAPI.login()
										end
										]]--
									elseif (type == "me/friends") then
										-- Retrieve only friends
										
										local data = response.data
										local friends = {}
										
										if (data and #data > 0) then
										
											for a=1,#data do
											
												local userid = data[a].id
												local username = data[a].name
												if (userid and username) then
													print(userid, username)
													friends[userid] = username
													
													table.insert(fbPhotoQueue, userid)
												end
												
											end
										end
																				
										self.friends = friends
										fbProcessPhoto() -- Get friends photos
										
										print("FRIENDS ", #friends)
										
										--ParseAPI.addFriends()
									elseif (type == appId.."/scores") then
										-- Player and friends scores
										
										--print("Player and friends scores")
										local scene = sceneManager:getCurrentScene()
										if (scene and scene.draw_list) then
											local data = response.data
											
											scene.score_list = data
																						
											--[[
											scene.score_list[2] = {score = 1200, user = {id = "000000000000001", name = "John Smith"}}
											scene.score_list[3] = {score = 900, user = {id = "000000000000002", name = "Paolo Rossi"}}
											scene.score_list[4] = {score = 800, user = {id = "000000000000002", name = "Francoise"}}
											scene.score_list[5] = {score = 650, user = {id = "000000000000002", name = "Pedro Gonzalez"}}
											scene.score_list[6] = {score = 210, user = {id = "000000000000002", name = "Hannibal"}}
											]]--
											
											--print(json.encode(scene.score_list))
											scene:draw_list()
										end
									end
								end)
	facebook:addEventListener(Event.REQUEST_ERROR, 
							function(event) 
								print("request error", event.errorCode, event.errorDescription)
								
								local scene = sceneManager:getCurrentScene()
								if (scene and scene.requestError) then
									scene:requestError()
								end
							end)
end

-- Login complete callback
function Social:onLoginComplete(event)
	print("Login complete")
	
	self.connected = true
	self.error = false
	
	self:getAccessToken()
	self:getExpirationDate()
	
	-- The following methods are only executed once
	self:getUserInfo()
	--self:getFriends()
	--self:getScores()
	
	--self:sendScore(3800)
	--self:readScore()
	
	local scene = sceneManager:getCurrentScene()
	if (scene and scene.onLoginComplete) then
		scene:onLoginComplete()
		self.scene = scene
	end
end

-- Login error callback
function Social:onLoginError(event)
	print("Login error")
													
	self.error = true
	
	self.scene = sceneManager:getCurrentScene()
	if (self.scene and self.scene.loginError) then
		self.scene:loginError()
	end
end

-- Facebook login
function Social:login()
	if (not self.connected) then
		facebook:login(appId, {"public_profile", "user_friends", "publish_actions"})
	end
end

-- Facebook logout
function Social:logout()
	
	--if (self:isConnected()) then
		facebook:logout()
	--end
end

-- Get access token
function Social:getAccessToken()
	self.accessToken = facebook:getAccessToken()
end

-- Retrieve access token expiration date
function Social:getExpirationDate()
	self.expirationDate = facebook:getExpirationDate()
end

-- Get user info
function Social:getUserInfo()
	
	if (self.connected) then
		facebook:getProfile()
	end
end

-- Send score to Facebook
function Social:sendScore(score)

	if (self.connected) then
		print("Send score to facebook "..score)
		local parameters = {
			score = score,
			fields = "firstname"	
		}
		facebook:postScore(parameters)
	end
end

--Invite some friends to play the game. Open request dialog and select friends to invite
function Social:inviteFriends(message)
	
	if (self.connected) then
	
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
	
	if (self.connected) then
		if not playerId then
			playerId = "me"
		end
	
		facebook:get(playerId.."/scores")
	end
end

-- Read scores for players and friends (https://developers.facebook.com/docs/games/scores/)
function Social:getScores()
	if (self.connected) then
		facebook:get(appId.."/scores")
	end
end

-- Share a post on Wall
function Social:feed(userId)

	if (self.connected) then
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
	
	if (self.connected) then
		local params = {
			title = appName.." request",
			message = "Check out this awesome app",
			to = userId
		}
		facebook:dialog("apprequests", params)
	end
end

-- Get friends list
function Social:getFriends()
	if (self.connected) then
		facebook:getFriends()
	end
end

-- Get pending request (invitation notification)
function Social:getRequest()
	if (self.connected) then
		facebook:graphRequest("me/requests")
	end
end

-- Return true access token already exists
function Social:wasConnected()

	local access_token = facebook:getAccessToken()
	local result = not (access_token == "")
	return result
end