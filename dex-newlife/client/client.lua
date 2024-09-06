ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterCommand(Config.Burgernewlifecommand, function()
    handleNewLife(false)
    TriggerServerEvent('newlife:clearInventory')
end)

RegisterCommand(Config.Politienewlifecommand, function()
    handleNewLife(true)
end)

function handleNewLife(isPolice)
    local playerPed = PlayerPedId()
    if IsEntityDead(playerPed) then
        if isPolice then
            if isPoliceJob() then
                TriggerEvent('ox_lib:openMenu', isPolice)
            else
                TriggerEvent('ox_lib:notify', 'Je bent geen politie agent!', 'error')
            end
        else
            TriggerEvent('ox_lib:openMenu', isPolice)
        end
    else
        TriggerEvent('ox_lib:notify', Config.Nietdoodopnewlife, 'error')
    end
end

RegisterNetEvent('ox_lib:openMenu')
AddEventHandler('ox_lib:openMenu', function(isPolice)
    local menuOptions = {}

    if isPolice then
        menuOptions = {
            {
                title = '🚓 Politie Blokkenpark',
                description = 'Teleport naar Blokkenpark voor politie',
                event = 'ox_lib:teleportToLocation',
                args = { coords = Config.Blokkenpark, isPolice = true }
            },
            {
                title = '🚓 Politie HB',
                description = 'Teleport naar Politie HB',
                event = 'ox_lib:teleportToLocation',
                args = { coords = Config.Politie, isPolice = true }
            },
            {
                title = '❌ Sluiten',
                description = 'Sluit dit menu',
                event = 'ox_lib:closeMenu'
            }
        }
    else
        menuOptions = {
            {
                title = '🚗 Blokkenpark',
                description = 'Teleport naar Blokkenpark',
                event = 'ox_lib:teleportToLocation',
                args = { coords = Config.Blokkenpark, isPolice = false }
            },
            {
                title = '🏥 Ziekenhuis',
                description = 'Teleport naar Ziekenhuis',
                event = 'ox_lib:teleportToLocation',
                args = { coords = Config.Ziekenhuis, isPolice = false }
            },
            {
                title = '🏖️ Sandy',
                description = 'Teleport naar Sandy',
                event = 'ox_lib:teleportToLocation',
                args = { coords = Config.Sandy, isPolice = false }
            },
            {
                title = '🌲 Paleto',
                description = 'Teleport naar Paleto',
                event = 'ox_lib:teleportToLocation',
                args = { coords = Config.Paleto, isPolice = false }
            },
            {
                title = '❌ Sluiten',
                description = 'Sluit dit menu',
                event = 'ox_lib:closeMenu'
            }
        }
    end

    lib.registerContext({
        id = 'teleport_menu',
        title = isPolice and '🚓 Politie Newlife' or '🌴 Newlife',
        options = menuOptions
    })
    lib.showContext('teleport_menu')
end)

RegisterNetEvent('ox_lib:closeMenu')
AddEventHandler('ox_lib:closeMenu', function()
    lib.hideContext()
end)

RegisterNetEvent('ox_lib:notify')
AddEventHandler('ox_lib:notify', function(message, type)
    lib.notify({
        description = message,
        type = type,
        timeout = 5000
    })
end)

RegisterNetEvent('ox_lib:teleportToLocation')
AddEventHandler('ox_lib:teleportToLocation', function(data)
    local coords = data.coords
    local isPolice = data.isPolice
    if type(coords) == 'vector3' then
        local playerPed = PlayerPedId()
        ESX.Game.Teleport(playerPed, coords, function()
            if not isPolice and Config.Burgerclearloadout then
                RemoveAllPedWeapons(playerPed, true)
                TriggerServerEvent('newlife:clearInventory')
            end
            TriggerEvent('ox_lib:notify', Config.RespawnburgerDone, 'success')
            TriggerServerEvent('newlife:requestRevive', coords)
        end)
    else
        print('Invalid vector type: ', coords)
    end
end)

function isPoliceJob()
    local playerData = ESX.GetPlayerData()
    return playerData.job and playerData.job.name == Config.Politiejob
end