QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('turtlebait', function(source)
	local _source = source
	Player = QBCore.Functions.GetPlayer(_source)
	if Player.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "turtle")
		
		Player.removeInventoryItem('turtlebait', 1)
		TriggerClientEvent('QBCore:Notify', _source, "~g~You attach the turtle bait onto your fishing rod")
	else
		TriggerClientEvent('QBCore:Notify', _source, "~r~You dont have a fishing rod")
	end
	
end)

QBCore.Functions.CreateUseableItem('fishbait', function(source)
	local _source = source
	Player = QBCore.Functions.GetPlayer(_source)
	if Player.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "fish")
		
		Player.removeInventoryItem('fishbait', 1)
		TriggerClientEvent('QBCore:Notify', _source, "~g~You attach the fish bait onto your fishing rod")
		
	else
		TriggerClientEvent('QBCore:Notify', _source, "~r~You dont have a fishing rod")
	end
	
end)

QBCore.Functions.CreateUseableItem(Config.TurtleItem, function(source)
	local _source = source
	Player = QBCore.Functions.GetPlayer(_source)
	if QBCore.Functions.HasItem(Config.FishingRod) then
		TriggerClientEvent('fishing:setbait', _source, Config.TurtleItem)
		
		Player.removeInventoryItem('turtle', 1)
		TriggerClientEvent('QBCore:Notify', _source, "~g~You attach the turtle meat onto the fishing rod")
	else
		TriggerClientEvent('QBCore:Notify', _source, "~r~You dont have a fishing rod")
	end
end)

QBCore.Functions.CreateUseableItem(Config.FishingRod, function(source)
	local _source = source
	TriggerClientEvent('qb-fishing:startFishing', _source)
end)

RegisterNetEvent('qb-fishing:catch', function(bait)
	_source = source
	local rnd = math.random(1,100)
	Player = QBCore.Functions.GetPlayer(_source)
	if bait == "turtle" then
		if rnd >= Config.TurtleChance then
			if rnd >= Config.BreakChance then
				TriggerClientEvent('qb-fishing:setbait', _source, "none")
				TriggerClientEvent('QBCore:Notify', _source, Config.Language.brokeline)
				TriggerClientEvent('qb-fishing:stopFishing', _source)
				Player.removeInventoryItem('fishingrod', 1)
			else
				TriggerClientEvent('qb-fishing:setbait', _source, "none")
				if Player.getInventoryItem('shark').count > 4 then
					TriggerClientEvent('QBCore:Notify', _source, Config.Language.canthold)
				else
					TriggerClientEvent('QBCore:Notify', _source, Config.Language.caughtturtle)
					Player.Functions.AddItem('shark', 1)
				end
			end
		else
			if rnd >= 75 then
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', _source, Config.Language.canthold..)
				else
					TriggerClientEvent('QBCore:Notify', _source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
				
			else
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', _source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', _source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			end
		end
	else
		if bait == "fish" then
			if rnd >= 75 then
				TriggerClientEvent('qb-fishing:setbait', _source, "none")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', _source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', _source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			else
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', _source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', _source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			end
		end
		if bait == "none" then
			if rnd >= 70 then
				TriggerClientEvent('QBCore:Notify', _source, "~y~You are currently fishing without any equipped bait")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', _source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', _source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			else
				TriggerClientEvent('QBCore:Notify', _source, "~y~You are currently fishing without any equipped bait")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', _source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', _source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			end
		end
	end
end)

RegisterNetEvent("qb-fishing:lowmoney", function(money)
    local _source = source	
	local Player = QBCore.Functions.GetPlayer(_source)
	Player.removeMoney(money)
end)

RegisterNetEvent('qb-fishing:startSelling', function(item)
	local _source = source
	local Player  = QBCore.Functions.GetPlayer(_source)

	if item == "fish" then
		local fishCount = Player.getInventoryItem('fish').count

		if fishCount <= 4 then
			TriggerClientEvent('esx:showNotification', source, '~r~You dont have enough~s~ fish')			
		else
			Player.removeInventoryItem('fish', 5)
			local payment = Config.FishPrice.a
			payment = math.random(Config.FishPrice.a, Config.FishPrice.b) 
			Player.addMoney(payment)
		end
	elseif item == "turtle" then
		local turtleCount = Player.getInventoryItem('turtle').count

		if turtleCount <= 0 then
			TriggerClientEvent('esx:showNotification', source, '~r~You dont have enough~s~ turtles')			
		else
			Player.removeInventoryItem('turtle', 1)
			local payment = Config.TurtlePrice.a
			payment = math.random(Config.TurtlePrice.a, Config.TurtlePrice.b) 
			Player.addAccountMoney('black_money', payment)
		end
	elseif item == "shark" then
		local sharkCount = Player.getInventoryItem('shark').count

		if sharkCount <= 0 then
			TriggerClientEvent('esx:showNotification', source, '~r~You dont have enough~s~ sharks')			
		else
			Player.removeInventoryItem('shark', 1)
			local payment = Config.SharkPrice.a
			payment = math.random(Config.SharkPrice.a, Config.SharkPrice.b)
			Player.addAccountMoney('black_money', payment)
		end
	end
end)