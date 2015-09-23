
Billing = Core.class()

local NAME_GOOGLE = "com.google.play"
local NAME_SLIDEME = "SlideME"
local NAME_APPLAND = "Appland"
local NAME_YANDEX = "com.yandex.store"

local android = application:getDeviceInfo() == "Android"
local iOS = application:getDeviceInfo() == "iOS"

local google_key = 
		"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv8vvZyadoLLd58pE00M4s8Kdp024xCP2u7Z1kebawLGABU8voo0j7hAqeMc314V/LnYaRAqa/vT54K/18Mrsb8h4VraNSoXhZxM46t6jqdlcsz4zxGr+5XGpO15XMRuTwE2EKu0w06hR4XjTgX46Nx0NKkvhBCvvuB6vO89XpJLVQroiFwABbfc4X/eigwf3lPGtR78xTFuo7jHroUcqqaPzEVxZSQNp/4s9WUcn0XSLzqWxQSycPU+Cn6Ct9Jew4Eb8ew9n2m5stjTW55gf4wPHUuKHZrl4biGp2rCNG2gpiWvnUO+QE8QlEy0XsLo7cWIpULD2twlmyzLQjwmYVwIDAQAB"
		
local slideme_key = 
		"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2OAnOCFWwp+EhOj+ELnjY+7jpnsQPKu51HrFWRVJ/JJXm2UBOoWgH0788QBQpg13lxpR0yZxqtjSLER8anTc7eGDr5R8EgODGsnUYb2Hxy+DpUsjaFkuZFkIX91cOxuLvfRsyc7nL0JR5FqZ4s4wZzIJmlQmSJX6R4UJbzyV7jyvhErR749wM+4vgE1OrGqx2bXXhgJoVpbJs+1BuMAhH5SLyq8jUBxj+Npiv8rQOuPnmo+IXn3K21rTX78D+Ubz/Dr9iKI9U5hs8DSve0RZgECTdMPAZY6VBTJLGedIYG/iHa/qL+KLLBnqkvUAQVMY+6wBI8V3Hmx7eAgOH9edQQIDAQAB"
		
local appland_key = 
		"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDb+n05b/PshtsgjTKtWSXV4nC6zXV3DXhnBbncf6PszzIEyYxaXNzYyGHIokeH2CRNdDrRguAibQtSBNCAct3txJ3Kh2DPuzFZRlxW60eSdc+T3hldqAZld+3aTkZgLY5wzWr0vW2CGQVdOfhHuVjx5NsznedkeNUqfXTRQQE6iwIDAQAB"
		
local iab

local products

--products["test.purchased"] = "android.test.purchased"
--products["test.canceled"] = "android.test.canceled"

local prices = nil


-- Return true if the store is in the list
local function lookup(list, store)
	if (list and store) then
		for i=1, #list do
			if (store == list[i]) then
				return true
			end
		end
	end
	
	return false
end

-- Constructor
function Billing:init()

	if (android or iOS) then
		require "iab"
		local iaps = IAB.detectStores()
		
		if (iaps[1] == "google") then
			iab = IAB.new(iaps[1])
			iab:setUp(google_key)
			
			products = { 
				   dots_5000 = "dots_5000",
				   dots_15000 = "dots_15000", 
				   dots_45000 = "dots_45000",
				   dots_300000 = "dots_300000",
				   }
			iab:setProducts(products)
		
		--[[
		if (lookup(iaps, "open")) then
			print("setup open stores")
			iab = IAB.new("open")
			
			iab:setUp(NAME_GOOGLE, google_key)
			iab:setUp(NAME_SLIDEME, slideme_key)
			--iab:setUp(NAME_APPLAND, appland_key)
			
			products = { 
				   dots_5000 = "dots_5000",
				   dots_15000 = "dots_15000", 
				   dots_45000 = "dots_45000",
				   dots_300000 = "dots_300000",
				   }
			iab:setProducts(products)
		elseif iaps[1] == "amazon" then
			iab = IAB.new(iaps[1])
			--using amazon product identifiers
			--iab:setProducts({p1 = "amazonprod1", p2 = "amazonprod2", p3 = "amazonprod3"})
			
			products = { 
				   dots_15000 = "dots_15000", 
				   dots_45000 = "dots_45000",
				   dots_300000 = "dots_300000",
				   }
			iab:setProducts(products)
		]]--
		elseif iaps[1] == "ios" then
			iab = IAB.new(iaps[1])
			--using ios product identifiers
			local prefix = "es.jdbc.squaredots."
			products = { 
				   dots_5000 = prefix.."dots_5000",
				   dots_15000 = prefix.."dots_15000", 
				   dots_45000 = prefix.."dots_45000",
				   dots_300000 = prefix.."dots_300000",
				   }
			iab:setProducts(products)
		end
		
		-- If we have a supported store
		if iab then
			iab:isAvailable()
			iab:addEventListener(Event.AVAILABLE, self.onAvailable, self)
			
			--set which products are consumables
			iab:setConsumables({"dots_5000", 
								"dots_15000", 
								"dots_45000", 
								"dots_300000"})
			--iab:setConsumables({"test.purchased", "test.canceled", "p1", "p2"})
			
			-- When purchase is completed
			iab:addEventListener(Event.PURCHASE_COMPLETE, self.onPurchaseComplete, self)
			
			--if there was a purchase error
			iab:addEventListener(Event.PURCHASE_ERROR, 
								function(e)
									AlertDialog.new(getString("purchase_canceled"), e.error, "Ok"):show()
								end)
			
		end
	else
		prices = {
					dots_5000 = "0,61 €",
					dots_15000 = "1,21 €",
					dots_45000 = "1,82 €",
					dots_300000 = "2,42 €",
					}
	end
end

-- Submit a requestPurchase of product_id
function Billing:purchase(product_id)
	
	print("productId", product_id)
	
	if (product_id) then
		print("request a purchase: ", product_id)
				
		if iab then
			iab:purchase(product_id) --purchase something
			
			--iab:purchase("android.test.purchased")
			--iab:purchase("android.test.canceled")
			
		else
			self:onPurchaseComplete({productId = product_id})
		end
	end
	
end

-- When iab is available
function Billing:onAvailable(event)
	
	print("Billing:onAvailable")
	
	iab:requestProducts()
	iab:addEventListener(Event.PRODUCTS_COMPLETE, self.onRequestProductsOK, self)
	iab:addEventListener(Event.PRODUCTS_ERROR, self.onRequestProductsError, self)
end

-- When product are requested ok
function Billing:onRequestProductsOK(event)
	local products = event.products
	
	print("#products", #products)
	
	if (products) then
		prices = {}
		
		for a = 1, #products do
			local product = products[a]
			local productId = product.productId
			local price = product.price
						
			if (tonumber(price) ~= nil) then
				price = price.." USD"
			end
			
			prices[productId] = price
			
			print(productId)
			print(product.title, price)
		end
	end
	
	-- Sort prices table
	table.sort(prices, function(a,b) return a > b end)
	
	-- Show products in the scene if it is necessary
	local scene = sceneManager:getCurrentScene()
	if (scene and scene.show_products) then
		scene:show_products()
	end
end

-- When product are requested with error
function Billing:onRequestProductsError(event)
		
	AlertDialog.new("Error on requesting products", event.error, "Ok"):show()
end

-- When purchase is done
function Billing:onPurchaseComplete(event)
	print("Purchase completed", event.productId, event.receiptId)
	
	local productId = event.productId
	if (productId) then
		local num_dots = tonumber(string.sub(productId, 6)) -- Number of dots to add
		--print(num_dots)
		
		gameState:add_dots(num_dots)
		gameState:save()
		
		--iab:confirm(productId)
	
		AlertDialog.new(getString("purchase_completed"), num_dots..getString("dots_added"), "Ok"):show()
	else
		print("productId is nil")
	end
end

-- Returns current price for given productId
function Billing:getPrice(key)

	if (android or iOS) then
		local product_id = prices[key]
		return prices[product_id]
	else
		return prices[key]
	end
end

-- Get the list of prices
function Billing:getProductPrices()
	return prices
end