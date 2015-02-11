
Billing = Core.class()

local android = application:getDeviceInfo() == "Android"
local iOS = application:getDeviceInfo() == "iOS"

local google_key = 
		"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApk22FzlVuf5UyppEFvf3zs1KcGnJShKISvU2bLdqi+DzfgAwNf+/auc8A8K2WDqOjd4DTUcP9bCblLtx0UpNKnvAO6leBTTdxSmBbVO6PfEq2qJqR7/gN1LmGYokA3s8/0Sk0OjggCFDNTgAyssdS4qpkOIAbbpthuKfo5V7bW/0Dw+trTlvn3Y3KNZvglS2VB7a90PPLH14XEF2MnwBz0FOPFaLCVoau/J0C58SFSeOlzA+HwE8FCsygAS3aSkahtX+2XF0jVdJqZ28k6KiEJbOSNJ3lb9E1EvZ2ZpXIx9bpNcmkA58BeFhLectONS7e6wZNtA77jyU9LJOf8L4xQIDAQAB"
		
local products = { jewel_1000 = "jewel_1000",
				   jewel_3000 = "jewel_3000", 
				  -- jewel_8000 = "jewel_8000",
				   --jewel_20000 = "jewel_20000",
				   --jewel_50000 = "jewel_50000"
				   }
--products["test.purchased"] = "android.test.purchased"
--products["test.canceled"] = "android.test.canceled"

local iab
local prices = {}

-- When products are requested ok
local function onRequestProductsOK(event)
	local products = event.products
	print("#products", #products)
	
	if (products) then
		local a
		for a = 1, #products do
			local product = products[a]
			local productId = product.productId
			local price = product.price
			prices[productId] = price
			
			print(product.productId)
			print(product.title, product.price)
		end
	end
end

-- When products are requested with error
local function onRequestProductsError(event)
		
	AlertDialog.new("Error on requesting products", event.error, "Ok"):show()
end

-- When purchase is done
local function onPurchaseComplete(event)
	print(event.productId, event.receiptId)
	
	local productId = event.productId
	if (productId) then
		local num_coins = tonumber(string.sub(productId, 7)) -- Number of jewels to add
		print(num_coins)
		
		gamestate:add_coins(num_coins)
		gamestate:save()
		
		--iab:confirm(productId)
	
		AlertDialog.new("Purchase Completed", "Purchase successfully completed", "Ok"):show()
	else
		print("productId is nil")
	end
end

-- When purchase is canceled or error happens
local function onPurchaseCanceled(event)
	AlertDialog.new("Purchase Canceled", event.error, "Ok"):show()
end

-- When iab is available
local function onAvailable(event)
	
	--iab:setConsumables({"test.purchased", "jewel_1000", "jewel_3000"})
	iab:setConsumables({"jewel_1000", "jewel_3000"})
	
	iab:requestProducts()
	iab:addEventListener(Event.PRODUCTS_COMPLETE, onRequestProductsOK)
	iab:addEventListener(Event.PRODUCTS_ERROR, onRequestProductsError)
	
	iab:addEventListener(Event.PURCHASE_COMPLETE, onPurchaseComplete)
	iab:addEventListener(Event.PURCHASE_ERROR, onPurchaseCanceled)
end

-- Set up in-app purchases
function Billing.setup()
	if (android or iOS) then
		require "iab"
		local iaps = IAB.detectStores()
		
		if (iaps[1] == "google") then
			iab = IAB.new(iaps[1])
			iab:setUp(google_key)
						
			iab:setProducts(products)
			
			--iab:restore()
			
		elseif iaps[1] == "amazon" then
			iab = IAB.new(iaps[1])
			--using amazon product identifiers
			iab:setProducts({p1 = "amazonprod1", p2 = "amazonprod2", p3 = "amazonprod3"})
		elseif iaps[1] == "ios" then
			iab = IAB.new(iaps[1])
			--using ios product identifiers
			iab:setProducts({p1 = "iosprod1", p2 = "iosprod2", p3 = "iosprod3"})
		end
		
		if iab then
			iab:isAvailable()
			iab:addEventListener(Event.AVAILABLE, onAvailable)
		end
		
	end
end

-- Submit a requestPurchase of productId
function Billing.purchase(productId)
	
	if (productId) then
		print("request a purchase: ", productId)
				
		if iab then
			iab:purchase(productId) --purchase something
			--iab:purchase("test.purchased")
			--iab:purchase("android.test.canceled")
			
		end
	end
	
end

-- Return product list
function Billing.getProductPrices()
	return prices
end

--[[
-- Returns current price for given productId
local function getPrice(productId)
	return prices[productId]
end
]]--