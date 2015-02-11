
Advertise = Core.class()

local android = application:getDeviceInfo() == "Android"
android = false
local iOS = application:getDeviceInfo() == "iOS"

local android_block_id = "ca-app-pub-3310916075178120/7448582299" 
local android_block2_id = "ca-app-pub-3310916075178120/1402048691"

local interval = math.random(1,2)

function Advertise.setup()
	if (android or iOS) then
		require "ads"
		
		if (android) then
		
			--print("android")
			admob = Ads.new("admob")
			admob:setKey(android_block_id)
			
			admob:addEventListener(Event.AD_RECEIVED, function(e)
														print("admob AD_RECEIVED")
													end)
			
			admob:addEventListener(Event.AD_FAILED, function(e)
														print("admob AD_FAILED", e.error)
													end)
		elseif (iOS) then
			iad = Ads.new("iad")
			
			iad:addEventListener(Event.AD_RECEIVED, function(e)
														print("iad AD_RECEIVED")
													end)
			
			iad:addEventListener(Event.AD_FAILED, function(e)
														print("iad AD_FAILED", e.error)
													end)
		end
	end
end

-- Show banner Ad
function Advertise.showBanner()
	
	if (android and admob) then
		admob:setKey(android_block2_id)
		admob:showAd("smart_banner")
		admob:setAlignment("center", "bottom")
	elseif (iOS and iad) then
		iad:showAd("banner")
		iad:setAlignment("center", "bottom")
	else
		print("Show banner")
	end
end

function Advertise.hideBanner()
	if (android and admob) then
		admob:hideAd("smart_banner")
	elseif (iOS and iad) then
		iad:hideAd("banner")
	else
		print("Hide banner")
	end
end

-- Show interstitial Ad
function Advertise.showInterstitial()

	if (android and admob) then
		admob:setKey(android_block_id)
		admob:showAd("interstitial")
	elseif (iOS and iad) then
		iad:showAd("interstitial")
	else
		print("Show interstitial")
	end
end