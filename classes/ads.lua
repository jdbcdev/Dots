
Advertise = Core.class()

local android = application:getDeviceInfo() == "Android"
--android = false
local iOS = application:getDeviceInfo() == "iOS"

-- Appodeal values
local appKey = "57e61d714057aaaa842a6e4c2dace86a5133428c44e798dd"

local INTERSTITIAL = 1
local VIDEO = 2
local BANNER = 4
local BANNER_BOTTOM = 8
local BANNER_TOP = 16
local BANNER_CENTER = 32
local ALL = 127
local ANY = 127

require "bit"

local admob_ios_blockid = { 
							interstitial = "ca-app-pub-6632080215577631/7765248305", 
							banner = "ca-app-pub-6632080215577631/9241981500"
							}

function Advertise.setup()
	if (android or iOS) then
		require "ads"
		
		if (android) then
			
			appodeal = Ads.new("appodeal")
			appodeal:setKey(appKey)
						
			appodeal:addEventListener(Event.AD_RECEIVED, function(e)
														print("appodeal AD_RECEIVED")
													end)
			
			appodeal:addEventListener(Event.AD_FAILED, function(e)
														print("appodeal AD_FAILED", e.error)
													end)
		elseif (iOS) then
			iad = Ads.new("iad")
			
			iad:addEventListener(Event.AD_RECEIVED, function(e)
														print("iad AD_RECEIVED")
													end)
			
			iad:addEventListener(Event.AD_FAILED, function(e)
														print("iad AD_FAILED", e.error)
														if (e and e.type == "interstitial") then -- Interstitial
															admob:setKey(admob_ios_blockid["interstitial"])
															admob:showAd("interstitial")
														elseif (e and e.type == "banner") then
															admob:setKey(admob_ios_blockid["banner"])
															admob:showAd("smart_banner")
															admob:setAlignment("center", "bottom")
														end
													end)
													
			admob = Ads.new("admob")
		end
	end
end

-- Show banner Ad
function Advertise.showBanner()
	
	if (android and appodeal) then
		appodeal:showAd(BANNER_BOTTOM)
	elseif (iOS and iad) then
		iad:showAd("banner")
		iad:setAlignment("center", "bottom")
	else
		print("Show banner")
	end
end

-- Hide banner Ad
function Advertise.hideBanner()
	if (android and appodeal) then
		appodeal:hideAd(BANNER_BOTTOM)
	elseif (iOS and iad) then
		iad:hideAd("banner")
		admob:hideAd("smart_banner")
	else
		print("Hide banner")
	end
end

-- Show interstitial or video Ad
function Advertise.showInterstitial()

	if (android and appodeal) then
		appodeal:showAd(bit.bor(VIDEO, INTERSTITIAL))
	elseif (iOS and iad) then
		iad:showAd("interstitial")
		--admob:setKey(admob_ios_blockid["interstitial"])
		--admob:showAd("interstitial")
	else
		print("Show interstitial")
	end
end