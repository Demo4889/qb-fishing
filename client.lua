QBCore = exports['qb-core']:GetCoreObject()

local config = Config
local PlayerJob = nil
local fishing = false
local pause = false
local pausetimer = 0
local correct = 0
local bait = "none"
local blips = {}
local models = {}

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
		QBCore.Functions.Notify(config.Language.nofishveh, "error", 3000)
	else
		if (pos.y >= 7700 or pos.y <= -4000) or (pos.x <= -3700 or pos.x >= 4300) then
			QBCore.Functions.Notify(config.Language.startedfishing, "success", 3000)
			TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true)
			fishing = true
		else
			QBCore.Functions.Notify(config.Language.furthershore, "error", 3000)
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
	if config.UseTarget then
		
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
		local FishTime = math.random(config.TimeToFish.min, config.TimeToFish.max)
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
			header = config.Language.menuheader,
			isMenuHeader = true
		}
	}

	local Vehicles = config.RentalBoats.citizens
	local EmergencyVehicles = config.RentalBoats.emergency

	for k,v in pairs(config.EmergencyJobs) do
		if PlayerJob ~= v then
			for veh, label in pairs(Vehicles) do
				vehicleMenu[#vehicleMenu+1] = {
					header = label,
					txt = "",
					params = {
						event = "qb-fishing:client:getVehicle",
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
						event = "qb-fishing:client:getVehicle",
						args = {
							vehicle = veh
						}
					}
				}
			end
		end
	end

	vehicleMenu[#vehicleMenu+1] = {
        header = config.Language.closemenu,
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

function placePoints()
	for _,sales in pairs(config.SalesLocations) do
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

	for _,rentals in pairs(config.BoatRentals) do
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

		if rentals.npc then
			RequestModel(GetHashKey(rentals.ped.model))

			while not HasModelLoaded(GetHashKey(rentals.ped.model)) do
				Wait(1)
			end

			local model = CreatePed(2, GetHashKey(rentals.ped.model), rentals.ped.coords.x, rentals.ped.coords.y, rentals.ped.coords.z - 1.0, rentals.ped.coords.w, true, false)

			PlaceObjectOnGroundProperly(model)
			FreezeEntityPosition(model, true)
			SetEntityInvincible(model, true)
			SetBlockingOfNonTemporaryEvents(model, true)
			models[#models+1] = model
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
	end
end)