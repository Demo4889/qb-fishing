QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem(Config.FishBait, function(source)
	local Player = QBCore.Functions.GetPlayer(source)
	local rod = Player.Functions.GetItemByName(Config.FishingRod)
	if rod.count >= 1 then
		TriggerClientEvent('fishing:client:setBait', source, Config.FishBait)
		Player.Functions.RemoveItem(Config.FishBait, 1)
		TriggerClientEvent('QBCore:Notify', source, Config.Language.baitattached)
	else
		TriggerClientEvent('QBCore:Notify', source, Config.Language.norod)
	end
end)

QBCore.Functions.CreateUseableItem(Config.TurtleItem, function(source)
	local Player = QBCore.Functions.GetPlayer(source)
	local rodAmount = Player.Functions.GetItemByName(Config.FishingRod).amount
	if rodAmount >= 1 then
		TriggerClientEvent('fishing:client:setBait', source, Config.TurtleItem)
		Player.Functions.RemoveItem(Config.TurtleItem, 1)
		TriggerClientEvent('QBCore:Notify', source, Config.Language.baitattached)
	else
		TriggerClientEvent('QBCore:Notify', source, Config.Language.norod)
	end
end)

QBCore.Functions.CreateUseableItem(Config.FishingRod, function(source)
	TriggerClientEvent('qb-fishing:client:startFishing', source)
end)

RegisterNetEvent('qb-fishing:server:catchFish', function(bait)
	local rnd = math.random(1,100)
	local Player = QBCore.Functions.GetPlayer(source)
	if bait == "turtle" then
		if rnd >= Config.TurtleChance then
			if rnd >= Config.BreakChance then
				TriggerClientEvent('qb-fishing:client:setbait', source, "none")
				TriggerClientEvent('QBCore:Notify', source, Config.Language.brokeline)
				TriggerClientEvent('qb-fishing:client:stopFishing', source)
				Player.removeInventoryItem('fishingrod', 1)
			else
				TriggerClientEvent('qb-fishing:client:setbait', source, "none")
				if Player.getInventoryItem('shark').count > 4 then
					TriggerClientEvent('QBCore:Notify', source, Config.Language.canthold)
				else
					TriggerClientEvent('QBCore:Notify', source, Config.Language.caughtturtle)
					Player.Functions.AddItem('shark', 1)
				end
			end
		else
			if rnd >= 75 then
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', source, Config.Language.canthold)
				else
					TriggerClientEvent('QBCore:Notify', source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
				
			else
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			end
		end
	else
		if bait == "fish" then
			if rnd >= 75 then
				TriggerClientEvent('qb-fishing:client:setbait', source, "none")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			else
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			end
		end
		if bait == "none" then
			if rnd >= 70 then
				TriggerClientEvent('QBCore:Notify', source, "~y~You are currently fishing without any equipped bait")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			else
				TriggerClientEvent('QBCore:Notify', source, "~y~You are currently fishing without any equipped bait")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('QBCore:Notify', source, "~r~You cant hold more fish")
				else
					TriggerClientEvent('QBCore:Notify', source, "~g~You caught a fish")
					Player.Functions.AddItem('fish', 1)
				end
			end
		end
	end
end)

RegisterNetEvent('qb-fishing:server:startSelling', function(item)
	local Player  = QBCore.Functions.GetPlayer(source)

	if item == "fish" then
		local fishCount = Player.Functions.GetItemByName(Config.FishItem).amount

		if fishCount <= 0 then
			TriggerClientEvent('QBCore:Notify', source, Config.Language.nofishsell)
		else
			Player.Functions.RemoveItem('fish', 5)
			local payment = math.random(Config.FishPrice.min, Config.FishPrice.max)
			Player.Functions.AddMoney("cash", payment, Config.Language.sellingfish)
		end
	elseif item == "turtle" then
		local turtleCount = Player.Functions.GetItemByName('turtle').amount

		if turtleCount <= 0 then
			TriggerClientEvent('QBCore:Notify', source, Config.Language.noturtlesell)
		else
			Player.Functions.RemoveItem('turtle', 1)
			local payment = math.random(Config.TurtlePrice.min, Config.TurtlePrice.max)
			Player.Functions.AddMoney("cash", payment, Config.Language.sellingturtles)
		end
	elseif item == "shark" then
		local sharkCount = Player.Functions.GetItemByName('shark').amount

		if sharkCount <= 0 then
			TriggerClientEvent('QBCore:Notify', source, Config.Language.nosharksell)
		else
			Player.Functions.RemoveItem('shark', 1)
			local payment = math.random(Config.SharkPrice.min, Config.SharkPrice.max)
			Player.Functions.AddMoney('cash', payment, Config.Language.sellingsharks)
		end
	end
end)