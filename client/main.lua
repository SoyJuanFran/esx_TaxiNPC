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
local targetX = nil
local targetY = nil
local taxiBlip = false
local globalTaxi = nil
local vehicle = nil
local customer = nil
local onTour = false
local driveFinish = nil
local aparcado = false
local fuera = false
local llegar = false
local heading = 1

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


RegisterNetEvent('esx_aiTaxi:callTaxi')
AddEventHandler('esx_aiTaxi:callTaxi', function(coords)
	TriggerEvent('taxi:getTaxi', function() end)
	local taxionline = 0

        ESX.TriggerServerCallback('taxi:Taxi', function(taxi)
            taxionline = taxi

  if taxionline < 2 then 
	if customer then
		ESX.ShowHelpNotification('Ya hay un taxi en camino')
	else
		customer = coords
		-- get best spawnpoint
		myCoords = GetEntityCoords(GetPlayerPed(-1))
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
				
				local ret, coordsTemp, heading = GetClosestVehicleNodeWithHeading(posX, posY, posZ, 1, 3.0, 0)
				local retval, coordsSide = GetPointOnRoadSide(coordsTemp.x, coordsTemp.y, coordsTemp.z)
				posX = coordsSide.x
				posY = coordsSide.y
				posZ = coordsSide.z
				--local carretera = IsPointOnRoad(posX, posY, posZ)
				--local seguro = GetSafeCoordForPed(posX, posY, posZ, true, 16)
				local agua = GetWaterHeightNoWaves(posX, posY, posZ)
				--local road = GetClosestRoad(posX, posY, posZ, 1000.0, 1, false)
				
				
				
				while agua do
				posX = posX - 2.0
				
				Wait(0)
				end
				--print(coordsSide, GetDistanceBetweenCoords(myCoords, coordsSide.x, coordsSide.y, coordsSide.z))
				
				cabeza = heading
					if GetDistanceBetweenCoords(myCoords, coordsSide.x, coordsSide.y, coordsSide.z, true) < 75 and GetDistanceBetweenCoords(myCoords, coordsSide.x, coordsSide.y, coordsSide.z) > 250 then
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
			
			SetEntityCanBeDamaged(ped, false)
			SetPedCanBeTargetted(ped, false)
			SetDriverAbility(ped, 1.0)
			SetDriverAggressiveness(ped, 0.0)
			SetBlockingOfNonTemporaryEvents(ped, true)
			SetPedConfigFlag(ped, 251, true)
			SetPedConfigFlag(ped, 64, true)
			SetPedStayInVehicleWhenJacked(ped, true)
			SetPedCanBeDraggedOut(ped, false)
		end
		if DoesEntityExist(globalTaxi) then
			ESX.Game.DeleteVehicle(globalTaxi)
		end
		--print(posX, posY, posZ, cabeza)
		ESX.Game.SpawnVehicle(vehicleHash, vector3(posX, posY, posZ), cabeza, function(callback_vehicle)
			platenum = math.random(1000, 9999)
			SetVehicleNumberPlateText(callback_vehicle, "TAXI"..platenum)
			TriggerServerEvent('shorty_slocks:breakIn', "TAXI"..platenum)
			TaskWarpPedIntoVehicle(ped, callback_vehicle, -1)
			SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)
			taxiBlip = true
			globalTaxi = callback_vehicle
			SetEntityAsMissionEntity(globalTaxi, true, true)
			Citizen.Wait(200)
			drive(customer.x, customer.y, customer.z, false, 'start')
		end)
	end
		else
  ESX.ShowNotification("Hay un taxista profesional conectado. Llámalo a él")
  end
 end)
	
end)

function WaitTaskToEnd(ped, task)
	while GetScriptTaskStatus(ped, task) == 0 do -- ?
		Wait(250)
	end
	while GetScriptTaskStatus(ped, task) == 1 do -- Performing the task
		Wait(250)
	end
end

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
		Citizen.Wait(0)
		inCar = false
		if customer ~= nil then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			--local matricula = GetVehicleNumberPlateText(vehicle)
			--local matricula1 = GetVehicleNumberPlateText(globalTaxi)
			
			--if matricula == matricula1 and matricula ~= nil and matricula1 ~= nil then
			if vehicle == globalTaxi then
				inCar = true
				local waypoint = GetFirstBlipInfoId(8)
				if not DoesBlipExist(waypoint) and not onTour then
					ESX.ShowHelpNotification('Marca en el GPS donde quieres ir')
					Citizen.Wait(2000)
					aparcado = true
				else
					if aparcado then
						ESX.ShowHelpNotification('Pulsa ~INPUT_PICKUP~ para empezar el viaje')
					end
					if IsControlJustReleased(0, Keys['E']) then
						aparcado = false
						tx, ty, tz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypoint, Citizen.ResultAsVector()))
						if not onTour then
							if not targetX then
								targetX = tx
								targetY = ty
								targetZ = tz
							end
							drive(tx, ty, tz, false, false)
							onTour = true
							Citizen.Wait(15000)
							route2 = CalculateTravelDistanceBetweenPoints(customer.x, customer.y, customer.z, targetX, targetY, targetZ)
							exact = (route2/1000) * 110
							price = math.floor(exact)
							--TriggerServerEvent('esx_aiTaxi:pay', 0)
							TriggerServerEvent('esx_aiTaxi:pay', price)
						end
					end
					--if IsControlJustReleased(0, Keys['H']) then
					--	drive(tx, ty, tz, false, 'turbo')
					--	TriggerEvent('esx:showNotification', 'Turbo activado.')
					--end
				end
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

--distancechecks
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if customer ~= nil then
			myCoords = GetEntityCoords(GetPlayerPed(-1))
			taxiCoords = GetEntityCoords(ped)
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			--print(vehicle, globalTaxi, onTour, aparcado)
			if vehicle == globalTaxi then

				route = CalculateTravelDistanceBetweenPoints(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z)
				fuera = true
				--check distance between me and the destination
				--print(GetDistanceBetweenCoords(myCoords, targetX, targetY, taxiCoords.z))
				--TriggerEvent('esx:showNotification', 'Puedes pulsar "Control Izquierdo" 3 veces para detener el taxi')
				--if IsControlJustReleased(0, Keys['LEFTCTRL']) then
				--	parking(taxiCoords.x, taxiCoords.y, taxiCoords.z)
				--	Citizen.Wait(5000)
				--	TaskLeaveVehicle(GetPlayerPed(-1), globalTaxi, 1)
				--	Citizen.Wait(5000)
				--	atTarget()
				--end
				
				--print("llegar", GetDistanceBetweenCoords(myCoords, targetX, targetY, myCoords.z))
				if GetDistanceBetweenCoords(myCoords, targetX, targetY, myCoords.z) < 25 then
					TaskVehiclePark(ped, globalTaxi,targetX, targetY, myCoords.z, 0.0, 0, 500.0, true)
					WaitTaskToEnd(ped, 567490903)
					--TaskVehicleDriveToCoordLongrange(ped, globalTaxi, targetX, targetY, myCoords.z, 2.0, 524863, 6.0)
					Citizen.Wait(1000)
					atTarget()
					--WaitTaskToEnd(ped, 567490903)
				end	
			else 
				if fuera then
					if GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, taxiCoords.x, taxiCoords.y, myCoords.z, true) > 15 then
						--print("salir coche")
						atTargetFIN('cancel')
						fuera = false
					end
				end
			end
			
			
			--check if taxi is next to me 
			if customer ~= nil then
				local distanceMeTaxi = GetDistanceBetweenCoords(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z, true)
				
				if distanceMeTaxi <= 8 then
					if not parkingDone then
						parking(customer.x, customer.y, customer.z)
						if llegar then
							TriggerEvent('esx:showNotification', 'Ya está tu taxi aqui')
							llegar = false
							
						end	
					end
					if GetDistanceBetweenCoords(customer.x, customer.y, customer.z, taxiCoords.x, taxiCoords.y, taxiCoords.z, true) <= 5 then
						if taxiArrived == false then
							TaskVehicleDriveToCoordLongrange(ped, globalTaxi, taxiCoords.x, taxiCoords.y, taxiCoords.z, 2.0, 524863, 6.0)
						end
						taxiArrived = true
					end
				end
			end
		else
			Citizen.Wait(3000)
		end
		if fuera then
			if vehicle ~= globalTaxi then
				if GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, taxiCoords.x, taxiCoords.y, myCoords.z, true) > 15 then
					--print("salir coche")
					atTargetFIN('cancel')
					fuera = false
				end
			end
		end
	end
end)

--keycontrol
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if customer ~= nil then
			if taxiArrived and not inCar and not onWayBack and not fuera then
				myCoords = GetEntityCoords(GetPlayerPed(-1))
				taxiCoords = GetEntityCoords(ped)
				if GetDistanceBetweenCoords(myCoords, taxiCoords.x, taxiCoords.y, taxiCoords.z) < 9 and GetDistanceBetweenCoords(myCoords, taxiCoords.x, taxiCoords.y, taxiCoords.z) > 6 then
					WaitTaskToEnd(ped, 567490903)
					--TaskVehicleDriveToCoordLongrange(ped, globalTaxi, taxiCoords.x, taxiCoords.y, taxiCoords.z, 2.0, 524863, 6.0)
					--WaitTaskToEnd(ped, 567490903)
				end
				if GetDistanceBetweenCoords(myCoords, taxiCoords.x, taxiCoords.y, myCoords.z) < 6 then
					ESX.ShowHelpNotification('Pulsa ~INPUT_ENTER~ para entrar')
						
					--if IsControlJustReleased(0, Keys['E']) then
					--	TaskEnterVehicle(GetPlayerPed(-1), globalTaxi, 1000, math.random(0,2), 2.0, 1, 0)
						-- TaskWarpPedIntoVehicle(GetPlayerPed(-1), globalTaxi, math.random(0,2))
					--end
				end
			end
		else
			Citizen.Wait(3000)
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
		else
			Citizen.Wait(3000)
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
		else
			Citizen.Wait(5000)
		end
	end
end)

function atTarget(cancel)
	cancelTaxi = false
	if cancel then
		
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if vehicle ~= globalTaxi then
			TriggerEvent('esx:showNotification', 'El Taxi fue cancelado.')
			cancelTaxi = true
			fuera = false
			Citizen.Wait(1000)
			TriggerEvent('esx:showNotification', 'Espera 15 segundos antes de volver a pedir otro')
		else
			TriggerEvent('esx:showNotification', 'El Taxi no puede ser cancelado si vas montado en el')
			
			fuera = false
			return
		end
	end
	if not cancelTaxi then
		ESX.ShowHelpNotification('Hemos llegado al destino')
		Citizen.Wait(2000)
		TaskLeaveVehicle(GetPlayerPed(-1), globalTaxi, 1)
		Citizen.Wait(15000)
		
	end
	onWayBack = true
	customer = nil
	targetX = nil
	targetY = nil
	taxiBlip = nil
	fuera = false
	RemoveBlip(CarBlip)
	parkingDone = false
	taxiArrived = false
	llegar = true
	onTour = false
	onWayBack = false
	drive(26.92, -1736.77, 28.3, true, 'end')
	ped = nil
	globalTaxi = nil
end

function atTargetFIN(cancel)
	cancelTaxi = false
	if cancel then
		
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if vehicle ~= globalTaxi then
			cancelTaxi = true
			fuera = false
			Citizen.Wait(1000)
			TriggerEvent('esx:showNotification', 'El Taxi se ha ido.')
		end
	end
	if not cancelTaxi then
		TaskLeaveVehicle(GetPlayerPed(-1), globalTaxi, 1)
		Citizen.Wait(5000)
	end
	onWayBack = true
	customer = nil
	targetX = nil
	targetY = nil
	taxiBlip = nil
	fuera = false
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
	myCoords = GetEntityCoords(GetPlayerPed(-1))
	taxiCoords = GetEntityCoords(ped)
	if GetDistanceBetweenCoords(myCoords.x, myCoords.y, myCoords.z, taxiCoords.x, taxiCoords.y, myCoords.z, true) < 10 then
		--print("parar")
		TaskVehiclePark(ped, globalTaxi, x, y, z, 0.0, 0, 500.0, true)
		parkingDone = true
	end
end

function drive(x, y , z, delete, status)
	
	TaskVehicleDriveToCoordLongrange(ped, globalTaxi, x, y, z, 19.5, 524863, 15.0)
	
	if status == 'start' then
		Citizen.Wait(math.random(500,2000))
		ESX.ShowHelpNotification('Un conductor está de camino.')
		TaskVehicleDriveToCoordLongrange(ped, globalTaxi, x, y, z, 10.0, 524863, 6.0)
	elseif status == 'end' then
		ESX.ShowHelpNotification('Gracias por confiar en los taxistas.')
	elseif status == 'turbo' then
		TaskVehicleDriveToCoordLongrange(ped, globalTaxi, x, y, z, 990.0, 787260, 6.0)
	end
	if delete then
		Citizen.Wait(15000)
		DeletePed(ped)
		ESX.Game.DeleteVehicle(globalTaxi)
		ESX.ShowHelpNotification('Ya puedes pedir un taxi')
	end
end
