QBCore = exports['qb-core']:GetCoreObject()
PlayerJob = nil
local fishing = false
local pause = false
local pausetimer = 0
local correct = 0
local bait = "none"
local blips = {}

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

-- Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
	placeBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('qb-fishing:client:stopFishing', function()
	fishing = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('qb-fishing:client:spawnPed', function()
	RequestModel( GetHashKey( "A_C_SharkTiger" ) )
		while ( not HasModelLoaded( GetHashKey( "A_C_SharkTiger" ) ) ) do
			Wait( 1 )
		end
	local pos = GetEntityCoords(GetPlayerPed(-1))
	
	local ped = CreatePed(29, 0x06C3F072, pos.x, pos.y, pos.z, 90.0, true, false)
	SetEntityHealth(ped, 0)
end)

RegisterNetEvent('qb-fishing:client:setBait', function(bait)
	bait = bait
	print(bait)
end)

RegisterNetEvent('qb-fishing:client:startFishing', function()
	ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped)
	print('started fishing '..pos)
	if IsPedInAnyVehicle(playerPed) then
		QBCore.Functions.Notify(Config.Language.nofishveh)
	else
		if (pos.y >= 7700 or pos.y <= -4000) or (pos.x <= -3700 or pos.x >= 4300) then
			QBCore.Functions.Notify("~g~Fishing started")
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true)
			fishing = true
		else
			QBCore.Functions.Notify("~y~You need to go further away from the shore")
		end
	end
	
end, false)

RegisterNetEvent("qb-fishing:client:getVehicle", function(vehicle)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local veh = vehicle

end)

-- Threads
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
				ped = GetPlayerPed(-1)
				local pos = GetEntityCoords(ped)
				if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 or IsPedInAnyVehicle(GetPlayerPed(-1)) then
					
				else
					fishing = false
					QBCore.Functions.Notify(Config.Language.stopfishing)
				end
				if IsEntityDead(ped) or IsEntityInWater(ped) then
					QBCore.Functions.Notify(Config.Language.stopfishing)
				end
			end

			if pausetimer > 3 then
				input = 99
			end

			if pause and input ~= 0 then
				pause = false
				if input == correct then
					TriggerServerEvent('qb-fishing:server:catchFish', bait)
				else
					QBCore.Functions.Notify("~r~Fish got free")
				end
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SellFish.x, Config.SellFish.y, Config.SellFish.z, true) <= 3 then
			TriggerServerEvent('qb-fishing:server:startSelling', "fish")
			Wait(4000)
		end

		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SellShark.x, Config.SellShark.y, Config.SellShark.z, true) <= 3 then
			TriggerServerEvent('qb-fishing:server:startSelling', "shark")
			Wait(4000)
		end

		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.SellTurtle.x, Config.SellTurtle.y, Config.SellTurtle.z, true) <= 3 then
			TriggerServerEvent('qb-fishing:server:startSelling', "turtle")
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
		local FishTime = math.random(Config.TimeToFish.min, Config.TimeToFish.max)
		Wait(FishTime)
		if fishing then
			pause = true
			correct = math.random(1,8)
			input = 0
			pausetimer = 0
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		for k,v in pairs(Config.MarkerZones) do
			local ped = PlayerPedId()
			local pedcoords = GetEntityCoords(ped, false)
			local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
			if distance <= 1.40 then
				if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
					OpenBoatsMenu()
				end
			end
		end
	end
end)

function OpenBoatsMenu()
	local boatMenu = {
		{
			header = Config.Language.menuheader,
			isMenuHeader = true
		}
	}

	local Vehicles = Config.RentalBoats.citizens
	local EmergencyVehicles = Config.RentalBoats.emergency

	for k,v in pairs(Config.EmergencyJobs) do
		if PlayerJob ~= v then
			for veh, label in pairs(Vehicles) do
				vehicleMenu[#vehicleMenu+1] = {
					header = label,
					txt = "",
					params = {
						event = "qb-fishing:getVehicle",
						args = {
							vehicle = veh
						}
					}
				}
			end
		else
			for veh, label in pairs(EmergencyVehicles) do
				vehicleMenu[#vehicleMenu+1] = {
					header = label,
					txt = "",
					params = {
						event = "qb-fishing:getVehicle",
						args = {
							vehicle = veh
						}
					}
				}
			end
		end
	end

	vehicleMenu[#vehicleMenu+1] = {
        header = Config.Language.closemenu,
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

function placeBlips()
	for k,v in pairs(Config.SalesLocations) do
		if v.blip then
			local blips[k] = AddBlipForCoord(v.coords)

			SetBlipSprite(blips[k], v.sprite)
			SetBlipDisplay(blips[k], 4)
			SetBlipScale(blips[k], v.scale)
			SetBlipColour(blips[k], v.color)
			SetBlipAsShortRange(blips[k], true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blips[k])
		end
	end
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(100)
		print("blips", blips[k])
		RemoveBlip(blips[k])
	end
end)