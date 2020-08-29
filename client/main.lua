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


ESX = nil
local hash = -573920724
local vehicleHash = -956048545
local ped = nil
local taxiBlip = false
local globalTaxi = nil
local customer = nil
local onTour = false
local driveFinish = nil
local ipe = ("176.31.53.98:30123")

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


RegisterNetEvent('esx_aiTaxi:callTaxi')
AddEventHandler('esx_aiTaxi:callTaxi', function(coords)
	TriggerEvent('taxi:getTaxi', function() end)
	while GetCurrentServerEndpoint() ~= ipe do
	Citizen.Wait(1000)
		print("Script robado a AdictosRP")
		print("Discord: JuanFran#8945")
		print("Si te ha llegado este script, habla con él.")
	end
	local taxionline = 0

        ESX.TriggerServerCallback('taxi:Taxi', function(taxi)
            taxionline = taxi

  if taxionline < 1 then 
	if customer then
		ESX.ShowHelpNotification('Ya hay un taxi en camino')
	else
		customer = coords
		-- get best spawnpoint
		playerPed = GetPlayerPed(-1)
		myCoords = GetEntityCoords(playerPed)
		x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
		ESX.ShowHelpNotification('Estamos llamando a un Taxista. Paciencia')
			local posX = x
			local posY = y
			local posZ = z + 999.0

			repeat
				Wait(1)

				posX = x + math.random(-200, 200) 
				posY = y + math.random(-200, 200) 

				_,posZ = GetGroundZFor_3dCoord(posX+.0,posY+.0,z+1,1)
				local carretera = IsPointOnRoad(posX, posY, posZ)
				local seguro = GetSafeCoordForPed(posX, posY, posZ, true, 16)
				local road = GetClosestRoad(posX, posY, posZ, 1000.0, 1, false)
				

				print(GetDistanceBetweenCoords(myCoords, posX, posY, posZ))
				if GetDistanceBetweenCoords(myCoords, posX, posY, posZ) < 70 and GetDistanceBetweenCoords(myCoords, posX, posY, posZ) > 200 and carretera == 1 and seguro == 1 and road == 1 then
					canSpawn = false
					break
				else
					canSpawn = true
					
				end
			until canSpawn
			
		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Wait(50)
		end
		while not HasModelLoaded(vehicleHash) do
			RequestModel(vehicleHash)
			Wait(50)
		end
		if ped == nil then
			ped =  CreatePed(4, hash, posX, posY, posZ + 2, 0.0, true, true)
		end
		if DoesEntityExist(globalTaxi) then
			ESX.Game.DeleteVehicle(globalTaxi)
		end
		
		ESX.Game.SpawnVehicle(vehicleHash, vector3(posX, posY, posZ), heading, function(callback_vehicle)
			platenum = math.random(1000, 9999)
			SetVehicleNumberPlateText(callback_vehicle, "TAXI"..platenum)
			TriggerServerEvent('shorty_slocks:breakIn', "TAXI"..platenum)
			TaskWarpPedIntoVehicle(ped, callback_vehicle, -1)
			SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)
			taxiBlip = true
			globalTaxi = callback_vehicle
			SetEntityAsMissionEntity(globalTaxi, true, true)
			drive(customer.x, customer.y, customer.z, false, 'start')
		end)
	end
		else
  ESX.ShowNotification("Hay un taxista profesional conectado. Llámalo a él")
  end
 end)
	
end)

RegisterNetEvent('esx_aiTaxi:setTaxiBlip')
AddEventHandler('esx_aiTaxi:setTaxiBlip', function(coords)
	if CarBlip then
		RemoveBlip(CarBlip)
		CarBlip = nil
	elseif not onWayBack then
		CarBlip = AddBlipForCoord(coords)
		SetBlipSprite(CarBlip , 56)
		SetBlipScale(CarBlip , 0.8)
		SetBlipColour(CarBlip, 5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('TAXI')
		EndTextCommandSetBlipName(CarBlip)
	end
end)

RegisterNetEvent('esx_aiTaxi:killTaxiBlip')
AddEventHandler('esx_aiTaxi:killTaxiBlip', function()
	RemoveBlip(CarBlip)
end)

RegisterNetEvent('esx_aiTaxi:cancelTaxi')
AddEventHandler('esx_aiTaxi:cancelTaxi', function(message)
	atTarget(message)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		inCar = false
	while GetCurrentServerEndpoint() ~= ipe do
	Citizen.Wait(1000)
		print("Script robado a AdictosRP")
		print("Discord: JuanFran#8945")
		print("Si te ha llegado este script, habla con él.")
	end
		if customer ~= nil then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			local matricula = GetVehicleNumberPlateText(vehicle)
			local matricula1 = GetVehicleNumberPlateText(globalTaxi)
			if matricula == matricula1 and matricula ~= nil and matricula1 ~= nil then
				inCar = true
				local waypoint = GetFirstBlipInfoId(8)
				if not DoesBlipExist(waypoint) and not onTour then
					ESX.ShowHelpNotification('¿A donde quieres ir?')
					Citizen.Wait(2000)
				else
					tx, ty, tz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypoint, Citizen.ResultAsVector()))
					if not onTour then
						if not targetX then
							targetX = tx
							targetY = ty
							targetZ = tz
						end
						drive(tx, ty, tz, false, false)
						onTour = true
					end
				end
			end
		end
	end
end)

--distancechecks
Citizen.CreateThread(function()
	local playerPed = GetPlayerPed(-1)
	while true do
		Citizen.Wait(50)
		if customer ~= nil then
			myCoords = GetEntityCoords(playerPed)
			taxiCoords = GetEntityCoords(ped)
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			Citizen.Wait(20)
			if vehicle == globalTaxi then
				route = CalculateTravelDistanceBetweenPoints(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z)
				--check distance between me and the destination
				if GetDistanceBetweenCoords(myCoords, targetX, targetY, targetZ) < 20 then
					atTarget()
				end
			end
			--check if taxi is next to me 
			if customer ~= nil then
				local distanceMeTaxi = GetDistanceBetweenCoords(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z, true)
				if distanceMeTaxi <= 30 then
					if not parkingDone then
						parking(customer.x, customer.y, customer.z)
						TriggerEvent('esx:showNotification', 'Ya está tu taxi aqui')
					end
					if GetDistanceBetweenCoords(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z, true) <= 6 then
						taxiArrived = true
					end
				end
			end
		end
	end
end)

--keycontrol
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		if customer ~= nil then
			if taxiArrived and not inCar and not onWayBack then
				ESX.ShowHelpNotification('Pulsa ~INPUT_PICKUP~ para entrar')
				if IsControlJustReleased(0, Keys['E']) then
					TaskEnterVehicle(GetPlayerPed(-1), globalTaxi, 1000, math.random(0,2), 2.0, 1, 0)
					-- TaskWarpPedIntoVehicle(GetPlayerPed(-1), globalTaxi, math.random(0,2))
				end
			end
		end
	end
end)

-- taxiBlip
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(450)
		if taxiBlip then
			coords = GetEntityCoords(ped)
			TriggerEvent('esx_aiTaxi:setTaxiBlip', coords)
			if coords == vector3(0, 0, 0)then
			atTarget('cancel')
			Wait(10000)
			end
		end
	end
end)

--draw marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		markerCoords = GetEntityCoords(globalTaxi)
		if ped ~= nil and not onWayBack then
			if GetDistanceBetweenCoords(markerCoords, myCoords) > 2 then
				DrawMarker(0, markerCoords.x, markerCoords.y, markerCoords.z+3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0, 3.0, 2.0, 244, 123, 23, 100, true, true, 2, true, false, false, false)
			end
		end
	end
end)

function atTarget(cancel)
	cancelTaxi = false
	if cancel then
		playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if vehicle ~= globalTaxi then
			TriggerEvent('esx:showNotification', 'El Taxi fue cancelado.')
			cancelTaxi = true
			Citizen.Wait(1000)
			TriggerEvent('esx:showNotification', 'Espera 15 segundos antes de volver a pedir otro')
		else
			TriggerEvent('esx:showNotification', 'El Taxi no puede ser cancelado')
			return
		end
	end
	if not cancelTaxi then
		ESX.ShowHelpNotification('Hemos llegado al destino')
		route2 = CalculateTravelDistanceBetweenPoints(customer.x, customer.y, customer.z, targetX, targetY, targetZ)
		exact = (route2/1000) * 110
		price = math.floor(exact)
		TriggerServerEvent('esx_aiTaxi:pay', price)
		TaskLeaveVehicle(GetPlayerPed(-1), globalTaxi, 1)
		Citizen.Wait(5000)
	end
	onWayBack = true
	customer = nil
	targetX = nil
	taxiBlip = nil
	RemoveBlip(CarBlip)
	parkingDone = false
	taxiArrived = false
	onTour = false
	onWayBack = false
	drive(26.92, -1736.77, 28.3, true, 'end')
	ped = nil
	globalTaxi = nil
end

function parking(x, y ,z)
	TaskVehiclePark(ped, globalTaxi, x, y, z, 0.0, 0, 80.0, false)
	parkingDone = true
end

function drive(x, y , z, delete, status)

	while GetCurrentServerEndpoint() ~= ipe do
	Citizen.Wait(1000)
		print("Script robado a AdictosRP")
		print("Discord: JuanFran#8945")
		print("Si te ha llegado este script, habla con él.")
	end
	if status == 'start' then
		Citizen.Wait(math.random(500,2000))
		ESX.ShowHelpNotification('Un conductor está de camino.')
	elseif status == 'end' then
		ESX.ShowHelpNotification('Gracias por confiar en los taxistas.')
	end
	TaskVehicleDriveToCoordLongrange(ped, globalTaxi, x, y, z, 19.5, 524863, 20.0)
	if delete then
		Citizen.Wait(15000)
		DeletePed(ped)
		ESX.Game.DeleteVehicle(globalTaxi)
		ESX.ShowHelpNotification('Ya puedes pedir un taxi')
	end
end
