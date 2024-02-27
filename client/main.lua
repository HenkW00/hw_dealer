ESX = exports["es_extended"]:getSharedObject()

-- ESX = nil

-- Citizen.CreateThread(function()
--     while ESX == nil do
--         TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--         Citizen.Wait(0)
--     end
-- end)

RegisterNetEvent('hw_dealer:openMenu')
AddEventHandler('hw_dealer:openMenu', function()
    ESX.UI.Menu.CloseAll()

    local elements = {}
    for itemName, itemConfig in pairs(Config.Items) do
        table.insert(elements, {
            label = itemConfig.label,
            itemName = itemName,
            price = itemConfig.price,
            type = 'slider',
            value = 1,
            min = 1,
            max = 100
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dealer_menu', {
        title = 'Dealer',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local item = data.current.itemName
        local quantity = data.current.value

        TriggerServerEvent('hw_dealer:sellItem', item, quantity)
        if Config.Debug then
            print("^0[^1DEBUG^0] Player sold: ^3" .. quantity .. " ^3" .. item .. "^0")
        end
    end, function(data, menu)
        menu.close()
    end)
end)

Citizen.CreateThread(function()
    local pedModel = GetHashKey("a_m_m_skater_01")
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end

    local dealerPed = CreatePed(4, pedModel, Config.DealerLocation.x, Config.DealerLocation.y, Config.DealerLocation.z, Config.DealerHeading, false, true)
    SetEntityInvincible(dealerPed, true)
    SetBlockingOfNonTemporaryEvents(dealerPed, true)
    FreezeEntityPosition(dealerPed, true)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        if #(playerCoords - Config.DealerLocation) < 2.0 then
            ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to talk to the Dealer.")
            if IsControlJustReleased(1, 38) then 
                TriggerEvent('hw_dealer:openMenu')
            end
        end
    end
end)


RegisterCommand('opendealer', function()
    if Config.Debug then
    TriggerEvent('hw_dealer:openMenu')
    end
end, false)
