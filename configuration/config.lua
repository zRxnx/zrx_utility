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
        TriggerClientEvent('ox_lib:notify', player, {
            title = title,
            description = msg,
            type = type,
            duration = time,
            style = {
                color = color
            }
        })
    else
        exports.ox_lib:notify({
            title = title,
            description = msg,
            type = type,
            duration = time,
            style = {
                color = color
            }
        })
    end
end

--| Place here your alert dialog
Config.AlertDialog = function(header, content, centered, cancel)
    local alert = exports.ox_lib:alertDialog({
        header = header,
        content = content,
        centered = centered,
        cancel = cancel
    })

    return alert
end

--| Place here your text ui | ITS A TOGGLE
Config.ShowTextUI = function(text, icon, position)
    exports.ox_lib:showTextUI(text, {
        position = position or 'top-center',
        icon = icon or 'hand',
    })
end

--| Place here your hide text ui | ITS A TOGGLE
Config.HideTextUI = function()
    exports.ox_lib:hideTextUI()
end

--| Place here your is textui open | ITS A TOGGLE
Config.IsTextUIOpen = function()
    return exports.ox_lib:isTextUIOpen()
end