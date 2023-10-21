---@diagnostic disable: duplicate-set-field
if GetResourceState('ox_core') == 'missing' then return end
OX = exports.ox_core
OX_INV = exports.ox_inventory
BRIDGE = {
    Framework = {
        type = 'ox',
        version = GetResourceMetadata('ox_core', 'version', 0),
        core = OX,
    },

    Func = {}
}

--| Handlers |--
RegisterNetEvent('ox:playerLogout', function(player, userid, charid)
    TriggerEvent('zrx_utility:bridge:playerDropped', player)
end)

RegisterNetEvent('ox:playerLoaded', function(player, userid, charid)
    TriggerEvent('zrx_utility:bridge:playerLoaded', player)
end)

RegisterNetEvent('ox:setJob', function(player, job, lastJob) --| Doesnt exist
    TriggerEvent('zrx_utility:bridge:setJob', player, job, lastJob)
end)

RegisterNetEvent('ox:onPlayerDeath', function(data)
    TriggerEvent('zrx_utility:bridge:onPlayerDeath', source, data)
end)

--| Common |--
---@param player number
---@param weight number
BRIDGE.Func.setMaxWeight = function(player, weight)
    OX_INV:SetMaxWeight(player, weight)
end

---@param item string
---@param cb function
BRIDGE.Func.registerUsableItem = function(item, cb)
    print('registerUsableItem doesnt exist for OX')
end

---@param player number
BRIDGE.Func.isPlayerDead = function(player)
    return Config.DeathCheck(player)
end

---@param player number
---@param msg string
---@param title string
---@param type string
---@param color number
---@param time number
BRIDGE.Func.notification = function(player, msg, title, type, color, time)
    Config.Notification(player, msg, title, type, color, time)
end

---@param player number
--@return table
BRIDGE.Func.getBills = function(player)
    print('getBills doesnt exist for OX')
end

---@param player number
--@return table
BRIDGE.Func.getLicenses = function(player)
    print('getLicenses doesnt exist for OX')
end

--| Job |--
---@param player number
---@param job string
---@param grade number
BRIDGE.Func.setJob = function(player, job, grade)
    print('setJob doesnt exist for OX')
end

---@param job string
---@param grade number
--@return boolean
BRIDGE.Func.doesJobExist = function(job, grade)
    print('doesJobExist doesnt exist for OX')
end

--@return table
BRIDGE.Func.getJobs = function()
    print('getJobs doesnt exist for OX')
end

--| Society |--
---@param player number
--@return table
BRIDGE.Func.getSocietyMoney = function(job)
    print('getSocietyMoney doesnt exist for OX')
end

---@param job number
---@param amount number
BRIDGE.Func.addSocietyMoney = function(job, amount)
    print('addSocietyMoney doesnt exist for OX')
end

---@param job number
---@param amount number
BRIDGE.Func.setSocietyMoney = function(job, amount)
    print('setSocietyMoney doesnt exist for OX')
end

---@param job number
---@param amount number
BRIDGE.Func.removeSocietyMoney = function(job, amount)
    print('removeSocietyMoney doesnt exist for OX')
end

--| Account |--
---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.addAccountMoney = function(player, account, amount, reason)
    print('addAccountMoney doesnt exist for OX')
end

---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.setAccountMoney = function(player, account, amount, reason)
    print('setAccountMoney doesnt exist for OX')
end

---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.removeAccountMoney = function(player, account, amount, reason)
    print('removeAccountMoney doesnt exist for OX')
end

---@param player number
---@param account string
--@return table
BRIDGE.Func.getAccount = function(player, account)
    print('getAccount doesnt exist for OX')
end

--| Inventory |--
---@param player number
---@param item string
---@param count number
---@param metadata table
---@param slot number
---@param cb function
BRIDGE.Func.addInventoryItem = function(player, item, count, metadata, slot, cb)
    OX_INV:AddItem(player, item, count, metadata, slot, cb)
end

---@param player number
---@param item string
---@param count number
---@param metadata table
---@param slot number
BRIDGE.Func.removeInventoryItem = function(player, item, count, metadata, slot)
    OX_INV:RemoveItem(player, item, count, metadata, slot)
end

---@param player number
---@param item string
---@param count number
---@param metadata table
---@return boolean
BRIDGE.Func.canCarryItem = function(player, item, count, metadata)
    return OX_INV:CanCarryItem(player, item, count, metadata) or false
end

---@param player number
---@param sourceItem string
---@param sourceCount number
---@param targetItem string
---@param targetCount number
---@return boolean
BRIDGE.Func.canSwapItem = function(player, sourceItem, sourceCount, targetItem, targetCount)
    return OX_INV:CanSwapItem(player, sourceItem, sourceCount, targetItem, targetCount) or false
end

---@param player number
---@param item string
---@param metadata table
---@param strict boolean
---@return boolean
BRIDGE.Func.hasItem = function(player, item, metadata, strict)
    return OX_INV:GetItemCount(player, item, metadata, strict) > 0
end

--| Meta |--
---@param player number
---@param meta string
BRIDGE.Func.clearMeta = function(player, meta)
    Ox.GetPlayer(player).set(meta, nil)
end

---@param player number
---@param meta string
---@param index string
---@return table|number|string
BRIDGE.Func.getMeta = function(player, meta, index)
    return Ox.GetPlayer(player).get(meta)
end

---@param player number
---@param meta string
---@param index string
---@param subIndex string
BRIDGE.Func.setMeta = function(player, meta, index, subIndex, replicated)
    Ox.GetPlayer(player).set(meta, index, replicated)
end

--| Utility |--
---@param player number
--@return table
BRIDGE.Func.getVariables = function(player)
    print('getVariables doesnt exist for OX')
end