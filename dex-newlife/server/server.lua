ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('newlife:requestRevive')
AddEventHandler('newlife:requestRevive', function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent(Config.Revivetrigger, source)
end)

RegisterNetEvent('newlife:clearInventory')
AddEventHandler('newlife:clearInventory', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        for i = #xPlayer.inventory, 1, -1 do
            local item = xPlayer.inventory[i]
            if item.count > 0 then
                xPlayer.setInventoryItem(item.name, 0)
            end
        end
    end
end)