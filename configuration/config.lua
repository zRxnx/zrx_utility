Config = {}

--|
--| Supported Frameworks by default
--| Full: ESX
--| Partly: QBX, OX
--|

Config.Framework = {
    ESX = {
        inventory = 'ox_inventory', --| Types: default/ox_inventory/qs-inventory
        inventoryAccounts = { --| Leave everything false if using default inventory
            money = true,
            black_money = false,
            bank = false
        }
    }
}

--| Place here your death check
Config.DeathCheck = function(player)
    if IsDuplicityVersion() then
        return false
    else
        return IsPedFatallyInjured(PlayerPedId())
    end
end

--| Place here your notification
Config.Notification = function(player, msg, title, type, color, time)
    if IsDuplicityVersion() then
        TriggerClientEvent('esx:showNotification', player, msg, 'info')
    else
        TriggerEvent('esx:showNotification', msg, 'info')
    end
end