QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('turtlebait', function(source)
	local _source = source
	Player = QBCore.Functions.GetPlayer(_source)
	if Player.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "turtle")
		
		Player.removeInventoryItem('turtlebait', 1)
		TriggerClientEvent('fishing:message', _source, "~g~You attach the turtle bait onto your fishing rod")
	else
		TriggerClientEvent('fishing:message', _source, "~r~You dont have a fishing rod")
	end
	
end)

QBCore.Functions.CreateUseableItem('fishbait', function(source)
	local _source = source
	Player = QBCore.Functions.GetPlayer(_source)
	if Player.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "fish")
		
		Player.removeInventoryItem('fishbait', 1)
		TriggerClientEvent('fishing:message', _source, "~g~You attach the fish bait onto your fishing rod")
		
	else
		TriggerClientEvent('fishing:message', _source, "~r~You dont have a fishing rod")
	end
	
end)

QBCore.Functions.CreateUseableItem('turtle', function(source)
	local _source = source
	Player = QBCore.Functions.GetPlayer(_source)
	if Player.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', _source, "shark")
		
		Player.removeInventoryItem('turtle', 1)
		TriggerClientEvent('fishing:message', _source, "~g~You attach the turtle meat onto the fishing rod")
	else
		TriggerClientEvent('fishing:message', _source, "~r~You dont have a fishing rod")
	end
	
end)

QBCore.Functions.CreateUseableItem('fishingrod', function(source)
	local _source = source
	TriggerClientEvent('fishing:fishstart', _source)
end)

RegisterNetEvent('fishing:catch', function(bait)
	_source = source
	local weight = 2
	local rnd = math.random(1,100)
	Player = QBCore.Functions.GetPlayer(_source)
	if bait == "turtle" then
		if rnd >= 78 then
			if rnd >= 94 then
				TriggerClientEvent('fishing:setbait', _source, "none")
				TriggerClientEvent('fishing:message', _source, "~r~It was huge and it broke your fishing rod!")
				TriggerClientEvent('fishing:break', _source)
				Player.removeInventoryItem('fishingrod', 1)
			else
				TriggerClientEvent('fishing:setbait', _source, "none")
				if Player.getInventoryItem('turtle').count > 4 then
					TriggerClientEvent('fishing:message', _source, "~r~You cant hold more turtles")
				else
					TriggerClientEvent('fishing:message', _source, "~g~You caught a turtle\n~r~These are endangered species and are illegal to posses")
					Player.addInventoryItem('turtle', 1)
				end
			end
		else
			if rnd >= 75 then
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "~r~You cant hold more fish")
				else
					weight = math.random(4,9)
					TriggerClientEvent('fishing:message', _source, "~g~You caught a fish: ~y~~h~" .. weight .. "kg")
					Player.addInventoryItem('fish', weight)
				end
				
			else
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "~r~You cant hold more fish")
				else
					weight = math.random(2,6)
					TriggerClientEvent('fishing:message', _source, "~g~You caught a fish: ~y~~h~" .. weight .. "kg")
					Player.addInventoryItem('fish', weight)
				end
			end
		end
	else
		if bait == "fish" then
			if rnd >= 75 then
				TriggerClientEvent('fishing:setbait', _source, "none")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "~r~You cant hold more fish")
				else
					weight = math.random(4,11)
					TriggerClientEvent('fishing:message', _source, "~g~You caught a fish: ~y~~h~" .. weight .. "kg")
					Player.addInventoryItem('fish', weight)
				end
			else
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "~r~You cant hold more fish")
				else
					weight = math.random(1,6)
					TriggerClientEvent('fishing:message', _source, "~g~You caught a fish: ~y~~h~" .. weight .. "kg")
					Player.addInventoryItem('fish', weight)
				end
			end
		end
		if bait == "none" then
			if rnd >= 70 then
				TriggerClientEvent('fishing:message', _source, "~y~You are currently fishing without any equipped bait")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "~r~You cant hold more fish")
				else
					weight = math.random(2,4)
					TriggerClientEvent('fishing:message', _source, "~g~You caught a fish: ~y~~h~" .. weight .. "kg")
					Player.addInventoryItem('fish', weight)
				end
			else
				TriggerClientEvent('fishing:message', _source, "~y~You are currently fishing without any equipped bait")
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "~r~You cant hold more fish")
				else
					weight = math.random(1,2)
					TriggerClientEvent('fishing:message', _source, "~g~You caught a fish: ~y~~h~" .. weight .. "kg")
					Player.addInventoryItem('fish', weight)
				end
			end
		end
		if bait == "shark" then
			if rnd >= 82 then
				if rnd >= 91 then
					TriggerClientEvent('fishing:setbait', _source, "none")
					TriggerClientEvent('fishing:message', _source, "~r~It was huge and it broke your fishing rod!")
					TriggerClientEvent('fishing:break', _source)
					Player.removeInventoryItem('fishingrod', 1)
				else
					if Player.getInventoryItem('shark').count > 0  then
						TriggerClientEvent('fishing:setbait', _source, "none")
						TriggerClientEvent('fishing:message', _source, "~r~You cant hold more sharks")
					else
						TriggerClientEvent('fishing:message', _source, "~g~You caught a shark!\n~r~These are endangered species and are illegal to posses")
						TriggerClientEvent('fishing:spawnPed', _source)
						Player.addInventoryItem('shark', 1)
					end
				end
			else
				if Player.getInventoryItem('fish').count > 100 then
					TriggerClientEvent('fishing:message', _source, "~r~You cant hold more fish")
				else
					weight = math.random(4,8)
					TriggerClientEvent('fishing:message', _source, "~g~You caught a fish: ~y~~h~" .. weight .. "kg")
					Player.addInventoryItem('fish', weight)
				end
			end
		end
	end
end)

RegisterNetEvent("fishing:lowmoney", function(money)
    local _source = source	
	local Player = QBCore.Functions.GetPlayer(_source)
	Player.removeMoney(money)
end)

RegisterNetEvent('fishing:startSelling', function(item)

	local _source = source
	
	local Player  = QBCore.Functions.GetPlayer(_source)
			if item == "fish" then
					local FishQuantity = Player.getInventoryItem('fish').count
						if FishQuantity <= 4 then
						TriggerClientEvent('esx:showNotification', source, '~r~You dont have enough~s~ fish')			
					else   
						Player.removeInventoryItem('fish', 5)
						local payment = Config.FishPrice.a
						payment = math.random(Config.FishPrice.a, Config.FishPrice.b) 
						Player.addMoney(payment)
						
						
			end
				

				

				
			end
			if item == "turtle" then
				local FishQuantity = Player.getInventoryItem('turtle').count

				if FishQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, '~r~You dont have enough~s~ turtles')			
				else   
					Player.removeInventoryItem('turtle', 1)
					local payment = Config.TurtlePrice.a
					payment = math.random(Config.TurtlePrice.a, Config.TurtlePrice.b) 
					Player.addAccountMoney('black_money', payment)
					
					
				end
			end
			if item == "shark" then
				local FishQuantity = Player.getInventoryItem('shark').count

				if FishQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, '~r~You dont have enough~s~ sharks')			
				else   
					Player.removeInventoryItem('shark', 1)
					local payment = Config.SharkPrice.a
					payment = math.random(Config.SharkPrice.a, Config.SharkPrice.b)
					Player.addAccountMoney('black_money', payment)
					
					
				end
			end
			
	
end)

