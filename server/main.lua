ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--TriggerEvent('esx_phone:registerNumber', 'taxi', ('taxi_client'), true, true)
TriggerEvent('esx_sociedad:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('esx_aiTaxi:pay')
AddEventHandler('esx_aiTaxi:pay', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	base = xPlayer.getAccount('bank').money
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
		societyAccount = account
	end)
	if price > 1000 then
		xPlayer.removeAccountMoney('bank', 1000)
		societyAccount.addMoney(500)
		TriggerClientEvent('esx:showNotification', _source, 'Has pagado $1000. Gracias')
	elseif price == 0 then
		
		TriggerClientEvent('esx:showNotification', _source, 'A este viaje invito yo! No tienes que pagar nada')
	else
		xPlayer.removeAccountMoney('bank', price)
		societyAccount.addMoney(price / 50)
		TriggerClientEvent('esx:showNotification', _source, 'Has pagado $'..price..'. Gracias')
	end
end)


TriggerEvent('taxi:getTaxi', function(obj) end)

ESX.RegisterServerCallback('taxi:Taxi', function(source, cb)

  local xPlayer  = ESX.GetPlayerFromId(source)
  local xPlayers = ESX.GetPlayers()
    TaxiConnected = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'taxi' then
            TaxiConnected = TaxiConnected + 1
        end
    end
cb( TaxiConnected)
end)
