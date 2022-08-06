QBCore = exports['qb-core']:GetCoreObject()
PlayerJob = nil
local fishing = false
local lastInput = 0
local pause = false
local pausetimer = 0
local correct = 0
local bait = "none"

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Local Functions
local function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('qb-fishing:break', function()
	fishing = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('qb-fishing:spawnPed', function()
	RequestModel( GetHashKey( "A_C_SharkTiger" ) )
		while ( not HasModelLoaded( GetHashKey( "A_C_SharkTiger" ) ) ) do
			Wait( 1 )
		end
	local pos = GetEntityCoords(GetPlayerPed(-1))
	
	local ped = CreatePed(29, 0x06C3F072, pos.x, pos.y, pos.z, 90.0, true, false)
	SetEntityHealth(ped, 0)
end)

RegisterNetEvent('qb-fishing:setbait', function(bool)
	bait = bool
	print(bait)
end)

-- Threads
CreateThread(function()
	if Config.UseFishBlip then
		local fishBlip = AddBlipForCoord(Config.FishBlip.coords)

		SetBlipSprite (fishBlip, Config.FishBlip.sprite)
		SetBlipDisplay(fishBlip, 4)
		SetBlipScale(fishBlip, Config.FishBlip.scale)
		SetBlipColour(fishBlip, Config.FishBlip.color)
		SetBlipAsShortRange(fishBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Language.fishmarket)
		EndTextCommandSetBlipName(fishBlip)
	end

	if Config.UseTurtleBlip then
		local turtleBlip = AddBlipForCoord(Config.TurtleBlip.coords)

		SetBlipSprite (turtleBlip, Config.TurtleBlip.sprite)
		SetBlipDisplay(turtleBlip, 4)
		SetBlipScale(turtleBlip, Config.TurtleBlip.scale)
		SetBlipColour(turtleBlip, Config.TurtleBlip.color)
		SetBlipAsShortRange(turtleBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Language.turtledealer)
		EndTextCommandSetBlipName(turtleBlip)
	end

	if Config.UseSharkBlip then
		local sharkBlip = AddBlipForCoord(Config.SharkBlip.coords)

		SetBlipSprite (sharkBlip, Config.SharkBlip.sprite)
		SetBlipDisplay(sharkBlip, 4)
		SetBlipScale(sharkBlip, Config.SharkBlip.scale)
		SetBlipColour(sharkBlip, Config.SharkBlip.color)
		SetBlipAsShortRange(sharkBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Language.sharkdealer)
		EndTextCommandSetBlipName(sharkBlip)
	end

	for _, info in pairs(Config.MarkerZones) do
		info.rentalBlip = AddBlipForCoord(info.x, info.y, info.z)

		SetBlipSprite(info.rentalBlip, 455)
		SetBlipDisplay(info.rentalBlip, 4)
		SetBlipScale(info.rentalBlip, 1.0)
		SetBlipColour(info.rentalBlip, 20)
		SetBlipAsShortRange(info.rentalBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Language.boatrental)
		EndTextCommandSetBlipName(info.rentalBlip)
	end
end)

CreateThread(function()
    while true do
        Wait(0)
        for k in pairs(Config.MarkerZones) do
            DrawMarker(1, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 0, 150, 150, 100, 0, 0, 0, 0)
		end
    end
end)

CreateThread(function()
	while true do
		Wait(600)
		if pause and fishing then
			pausetimer = pausetimer + 1
		end
	end
end)

CreateThread(function()
	while true do
		Wait(5)
		if fishing then
			if IsControlJustReleased(0, Keys['1']) then
				input = 1
			elseif IsControlJustReleased(0, Keys['2']) then
				input = 2
			elseif IsControlJustReleased(0, Keys['3']) then
				input = 3
			elseif IsControlJustReleased(0, Keys['4']) then
				input = 4
			elseif IsControlJustReleased(0, Keys['5']) then
				input = 5
			elseif IsControlJustReleased(0, Keys['6']) then
				input = 6
			elseif IsControlJustReleased(0, Keys['7']) then
				input = 7
			elseif IsControlJustReleased(0, Keys['8']) then
				input = 8
			end

			if IsControlJustReleased(0, Keys['X']) then
				fishing = false
				QBCore.Functions.Notify(Config.Language.stopfishing)
			end

			if fishing then
				playerPed = GetPlayerPed(-1)
				local pos = GetEntityCoords(GetPlayerPed(-1))
				if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 or IsPedInAnyVehicle(GetPlayerPed(-1)) then
					
				else
					fishing = false
					QBCore.Functions.Notify(Config.Language.stopfishing)
				end
				if IsEntityDead(playerPed) or IsEntityInWater(playerPed) then
					QBCore.Functions.Notify(Config.Language.stopfishing)
				end
			end

			if pausetimer > 3 then
				input = 99
			end

			if pause and input ~= 0 then
				pause = false
				if input == correct then
					TriggerServerEvent('fishing:catch', bait)
				else
					QBCore.Functions.Notify("~r~Fish got free")
				end
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SellFish.x, Config.SellFish.y, Config.SellFish.z, true) <= 3 then
			TriggerServerEvent('qb-fishing:startSelling', "fish")
			Wait(4000)
		end

		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SellShark.x, Config.SellShark.y, Config.SellShark.z, true) <= 3 then
			TriggerServerEvent('qb-fishing:startSelling', "shark")
			Wait(4000)
		end

		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SellTurtle.x, Config.SellTurtle.y, Config.SellTurtle.z, true) <= 3 then
			TriggerServerEvent('qb-fishing:startSelling', "turtle")
			Wait(4000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1)
		DrawMarker(1, Config.SellFish.x, Config.SellFish.y, Config.SellFish.z , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 2.0, 0, 70, 250, 100, false, true, 2, false, false, false, false)
		DrawMarker(1, Config.SellTurtle.x, Config.SellTurtle.y, Config.SellTurtle.z , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 0, 1.0, 70, 250, 100, false, true, 2, false, false, false, false)
		DrawMarker(27, Config.SellShark.x, Config.SellShark.y, Config.SellShark.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 70, 250, 100, false, true, 2, false, false, false, false)
	end
end)

CreateThread(function()
	while true do
		local wait = math.random(Config.FishTime.a, Config.FishTime.b)
		Wait(wait)
		if fishing then
			pause = true
			correct = math.random(1,8)
			QBCore.Functions.Notify("~g~Fish is taking the bait \n ~h~Press " .. correct .. " to catch it")
			input = 0
			pausetimer = 0
		end
	end
end)

RegisterNetEvent('qb-fishing:fishstart', function()
	playerPed = GetPlayerPed(-1)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	print('started fishing' .. pos)
	if IsPedInAnyVehicle(playerPed) then
		QBCore.Functions.Notify("~y~You can not fish from a vehicle")
	else
		if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 then
			QBCore.Functions.Notify("~g~Fishing started")
			TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_FISHING", 0, true)
			fishing = true
		else
			QBCore.Functions.Notify("~y~You need to go further away from the shore")
		end
	end
	
end, false)

CreateThread(function()
	while true do
		Wait(0)
		for k in pairs(Config.MarkerZones) do
			local ped = PlayerPedId()
			local pedcoords = GetEntityCoords(ped, false)
			local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
			if distance <= 1.40 then
					DisplayHelpText('Press E to rent a boat')
					
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
						OpenBoatsMenu(Config.MarkerZones[k].xs, Config.MarkerZones[k].ys, Config.MarkerZones[k].zs)
					end
			elseif distance < 1.45 then
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)

function OpenBoatsMenu(x, y , z)
	local ped = PlayerPedId()
	PlayerData = ESX.GetPlayerData()
	local elements = {}
		table.insert(elements, {label = '<span style="color:green;">Dinghy</span> <span style="color:red;">2500$</span>', value = 'boat'})
		table.insert(elements, {label = '<span style="color:green;">Suntrap</span> <span style="color:red;">3500$</span>', value = 'boat6'})
		table.insert(elements, {label = '<span style="color:green;">Jetmax</span> <span style="color:red;">4500$</span>', value = 'boat5'})
		table.insert(elements, {label = '<span style="color:green;">Toro</span> <span style="color:red;">5500$</span>', value = 'boat2'})
		table.insert(elements, {label = '<span style="color:green;">Marquis</span> <span style="color:red;">6000$</span>', value = 'boat3'})
		
	--If user has police job they will be able to get free Police Predator boat
	if PlayerData.job.name == "police" then
		table.insert(elements, {label = '<span style="color:green;">Police Predator</span>', value = 'police'})
		table.insert(elements, {label = '<span style="color:green;">CG Predator</span>', value = 'police'})
		table.insert(elements, {label = '<span style="color:green;">CG Dinghy</span>', value = 'police'})
		table.insert(elements, {label = '<span style="color:green;">CG Executioner</span>', value = 'police'})
	end

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = 'Rent a boat',
		align    = 'top-right',
		elements = elements,
    }, function(data, menu)
		if data.current.value == 'boat' then
			TriggerServerEvent("fishing:lowmoney", 2500)
			QBCore.Functions.Notify('You rented a boat for', {255,0,255}, '$' .. 2500)
			SetPedCoordsKeepVehicle(ped, x, y , z)
			TriggerEvent('esx:spawnVehicle', "dinghy4")
		elseif data.current.value == 'boat2' then
			TriggerServerEvent("fishing:lowmoney", 5500)
			QBCore.Functions.Notify('You rented a boat for', {255,0,255}, '$' .. 5500)
			SetPedCoordsKeepVehicle(ped, x, y , z)
			TriggerEvent('esx:spawnVehicle', "TORO")
		elseif data.current.value == 'boat3' then
			TriggerServerEvent("fishing:lowmoney", 6000)
			QBCore.Functions.Notify('You rented a boat for', {255,0,255}, '$' .. 6000)
			SetPedCoordsKeepVehicle(ped, x, y , z)
			TriggerEvent('esx:spawnVehicle', "MARQUIS")
		elseif data.current.value == 'boat4' then
			TriggerServerEvent("fishing:lowmoney", 7500)
			QBCore.Functions.Notify('You rented a boat for', {255,0,255}, '$' .. 7500)
			SetPedCoordsKeepVehicle(ped, x, y , z)
			TriggerEvent('esx:spawnVehicle', "tug")
		elseif data.current.value == 'boat5' then
			TriggerServerEvent("fishing:lowmoney", 4500)
			QBCore.Functions.Notify('You rented a boat for', {255,0,255}, '$' .. 4500)
			SetPedCoordsKeepVehicle(ped, x, y , z)
			TriggerEvent('esx:spawnVehicle', "jetmax")
		elseif data.current.value == 'boat6' then
			TriggerServerEvent("fishing:lowmoney", 3500)
			QBCore.Functions.Notify('You rented a boat for', {255,0,255}, '$' .. 3500)
			SetPedCoordsKeepVehicle(ped, x, y , z)
			TriggerEvent('esx:spawnVehicle', "suntrap")
		elseif data.current.value == 'police' then
			QBCore.Functions.Notify('You took out a boat')
			SetPedCoordsKeepVehicle(ped, x, y , z)
			TriggerEvent('esx:spawnVehicle', "predator")
		end
    end,
	function(data, menu)
		menu.close()
		end
	)
end