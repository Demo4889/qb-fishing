local QBCore = exports['qb-core']:GetCoreObject()
local fishing = false
local pause = false
local pausetimer = 0
local correct = 0
local bait = "none"
local blips = {}
local models = {}
local inRentals = false
local rentalVehicles = {}

-- Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
	placePoints()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('qb-fishing:client:stopFishing', function()
	fishing = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('qb-fishing:client:spawnPed', function()
	RequestModel(GetHashKey("A_C_SharkTiger"))
		while not HasModelLoaded(GetHashKey("A_C_SharkTiger")) do
			Wait(1)
		end
	local pos = GetEntityCoords(GetPlayerPed(-1))
	
	local ped = CreatePed(29, GetHashKey("A_C_SharkTiger"), pos.x, pos.y, pos.z, 90.0, true, false)
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
		QBCore.Functions.Notify(Config.Language.nofishveh, "error", 3000)
	else
		if (pos.y >= 7700 or pos.y <= -4000) or (pos.x <= -3700 or pos.x >= 4300) then
			QBCore.Functions.Notify(Config.Language.startedfishing, "success", 3000)
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true)
			fishing = true
		else
			QBCore.Functions.Notify(Config.Language.furthershore, "error", 3000)
		end
	end
	
end, false)

RegisterNetEvent("qb-fishing:client:getVehicle", function(veh)
	for k,v in pairs(Config.BoatRentals) do
		local player = GetPlayerPed(-1)
		local pCoords = GetEntityCoords(player)
		local dist = #(pCoords - v.coords)

		if dist <= 5.0 then
			local rentalShop = k
			QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
				local pVehicle = NetToVeh(netId)
				exports['ps-fuel']:SetFuel(pVehicle, 100)
				SetEntityHeading(pVehicle, Config.BoatRentals[k].boatCoords.w)
				TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(pVehicle))
				TriggerServerEvent("qb-vehicletuning:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(pVehicle))
				rentalVehicles[#rentalVehicles+1] = pVehicle
			end, veh.vehicle, Config.BoatRentals[k].boatCoords, true)
		end
	end
end)

-- Threads
CreateThread(function()
	local boatZones = {}

	for k,v in pairs(Config.BoatRentals) do
		boatZones[#boatZones+1] = BoxZone:Create(
			vector3(v.coords.x, v.coords.y, v.coords.z), 2, 2, {
				name="box_zone",
				debugPoly = false,
				minZ = v.coords.z - 1,
				maxZ = v.coords.z + 1,
		})
	end

	local boatCombo = ComboZone:Create(boatZones, {name = "boatCombo", debugPoly = false})
	boatCombo:onPlayerInOut(function(isPointInside)
		if isPointInside then
			inRentals = true
			exports['qb-core']:DrawText(Config.Language.boat_rental)
		else
			inRentals = false
			exports['qb-core']:HideText()
		end
	end)
end)

-- Boat Rentals Thread
CreateThread(function()
	Wait(1000)
	while true do
		local sleep = 1000
		if inRentals then
			sleep = 5
			if IsControlJustReleased(0, 38) then
				OpenBoatsMenu()
			end
		else
			sleep = 1000
		end
		Wait(sleep)
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
		local FishTime = math.random(Config.TimeToFish.min, Config.TimeToFish.max)
		Wait(FishTime)
		if fishing then
			pause = true
			correct = math.random(1,8)
			pausetimer = 0
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

	local emergencyJob = false

	for k, v in pairs(Config.EmergencyJobs) do
		if (PlayerJob.name == 'police' or PlayerJob.name == 'ambulance') then
			emergencyJob = true
		end
	end

	if emergencyJob then
		for veh, label in pairs(Config.RentalBoats.Emergency) do
			boatMenu[#boatMenu+1] = {
				header = GetDisplayNameFromVehicleModel(GetHashKey(label)),
				txt = "",
				params = {
					event = "qb-fishing:client:getVehicle",
					args = {
						vehicle = label
					}
				}
			}
		end
	else
		for veh, label in pairs(Config.RentalBoats.Citizens) do
			boatMenu[#boatMenu+1] = {
				header = GetDisplayNameFromVehicleModel(GetHashKey(label)),
				txt = "",
				params = {
					event = "qb-fishing:client:getVehicle",
					args = {
						vehicle = label
					}
				}
			}
		end
	end

	boatMenu[#boatMenu+1] = {
        header = Config.Language.closemenu,
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }

    exports['qb-menu']:openMenu(boatMenu)
end

function placePoints()
	for _,sales in pairs(Config.SalesLocations) do
		if sales.blip then
			for _,marker in pairs(sales.coords) do
				local blip = AddBlipForCoord(marker.x, marker.y, marker.z)

				SetBlipSprite(blip, sales.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, sales.scale)
				SetBlipColour(blip, sales.color)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(sales.name)
				EndTextCommandSetBlipName(blip)
				blips[#blips+1] = blip
			end
		end

		if sales.npcs then
			for _,ped in pairs(sales.peds) do
				RequestModel(GetHashKey(ped.model))

				while not HasModelLoaded(GetHashKey(ped.model)) do
					Wait(1)
				end

				local model = CreatePed(2, GetHashKey(ped.model), ped.coords.x, ped.coords.y, ped.coords.z - 1.0, ped.coords.w, true, false)

				PlaceObjectOnGroundProperly(model)
				FreezeEntityPosition(model, true)
				SetEntityInvincible(model, true)
				SetBlockingOfNonTemporaryEvents(model, true)
				models[#models+1] = model
			end
		end
	end

	for _,rentals in pairs(Config.BoatRentals) do
		if rentals.blip then
			local blip = AddBlipForCoord(rentals.coords.x, rentals.coords.y, rentals.coords.z)

			SetBlipSprite(blip, rentals.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, rentals.scale)
			SetBlipColour(blip, rentals.color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(rentals.name)
			EndTextCommandSetBlipName(blip)
			blips[#blips+1] = blip
		end
	end
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(100)
		placePoints()
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k,v in pairs(blips) do
			RemoveBlip(k)
		end
		
		for k,v in pairs(models) do
			DeletePed(v)
		end
		
		for k,v in pairs(rentalVehicles) do
			print(k, v)
			DeleteVehicle(k)
		end
	end
end)