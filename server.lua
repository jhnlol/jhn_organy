ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

print("--------------------------------------------")
print("Author: Johny | DONT PASTE")
print("--------------------------------------------")
RegisterNetEvent("jhn_organy:xD")
AddEventHandler('jhn_organy:xD', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" then
        xPlayer.addInventoryItem('organ', 1)
    else
        -- trigger ban
        xPlayer.showNotification(`Nice Try cheater !`)
    end
end)

RegisterNetEvent("jhn_organy:xDe")
AddEventHandler('jhn_organy:xDe', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" then
        xPlayer.removeInventoryItem('organ', 1)
        xPlayer.addAccountMoney('money', 10000)
    else
        -- trigger ban
        xPlayer.showNotification(`Nice Try cheater !`)
    end
end)
