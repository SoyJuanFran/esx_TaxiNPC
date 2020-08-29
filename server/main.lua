ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('esx_aiTaxi:pay')
AddEventHandler('esx_aiTaxi:pay', function(price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	base = xPlayer.getAccount('bank').money
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
		societyAccount = account
	end)
	
	xPlayer.removeAccountMoney('bank', price)
	societyAccount.addMoney(price / 50)
	TriggerClientEvent('esx:showNotification', _source, 'Has pagado ~g~$'..price..'~s~. Gracias')
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