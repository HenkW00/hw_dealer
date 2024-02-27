ESX = exports["es_extended"]:getSharedObject()

-- ESX = nil
-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('hw_dealer:sellItem')
AddEventHandler('hw_dealer:sellItem', function(itemName, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemConfig = Config.Items[itemName]
    local item = xPlayer.getInventoryItem(itemName)

    if itemConfig == nil then
        TriggerClientEvent('esx:showNotification', source, '~r~This item cannot be sold.')
        return
    end

    if item == nil then
        TriggerClientEvent('esx:showNotification', source, '~r~You do not have this item.')
        return
    end

    if item.count >= quantity then
        local payment = itemConfig.price * quantity
        xPlayer.removeInventoryItem(itemName, quantity)
        xPlayer.addAccountMoney('black_money', payment)
        
        if Config.Debug then
            print("^0[^1DEBUG^0] Player ^5" .. tostring(source) .. "^0 sold: ^3" .. tostring(quantity) .. "x " .. tostring(itemName) ..  "^0 for: ^3$" .. tostring(payment))
        end

        PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({
            username = "Dealer Logs",
            embeds = {{
                ["color"] = 16711680,
                ["title"] = "**Item Sold**",
                ["description"] = "- Player **" .. xPlayer.name .. "** sold **" .. quantity .. "x " .. itemConfig.label .. "** for **$" .. payment .. "** (black money).\n\n**Date & Time:** " .. os.date("%Y-%m-%d %H:%M:%S"),
                ["footer"] = {
                    ["text"] = "HW Scripts | Dealer"
                }
            }},
        }), { ['Content-Type'] = 'application/json' })  

        TriggerClientEvent('esx:showNotification', source, '~y~You sold ' .. quantity .. 'x ' .. itemConfig.label .. ' for black money.')
    else
        TriggerClientEvent('esx:showNotification', source, '~r~You don\'t have enough of that item to sell.')
    end
end)