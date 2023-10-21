---@diagnostic disable: duplicate-set-field
if GetResourceState('ox_core') == 'missing' then return end
OX = exports.ox_core
OX_INV = exports.ox_inventory
LOADED = false
BRIDGE = {
    Framework = {
        type = 'ox',
        version = GetResourceMetadata('ox_core', 'version', 0),
        core = OX,
    },

    Func = {}
}

--| Handlers |--
RegisterNetEvent('ox:playerLoaded', function(userid, charid)
    LOADED = true
    TriggerEvent('zrx_utility:bridge:playerLoaded')
end)

RegisterNetEvent('ox:setJob', function(job, lastJob) --| Doesnt exist
    TriggerEvent('zrx_utility:bridge:setJob', job, lastJob)
end)

--| Common |--
---@return boolean
BRIDGE.Func.isPlayerDead = function()
    return Config.DeathCheck()
end

---@return boolean
BRIDGE.Func.isPlayerLoaded = function()
    return LOADED
end

---@param msg string
---@param title string
---@param type string
---@param color number
---@param time number
BRIDGE.Func.notification = function(msg, title, type, color, time)
    Config.Notification(nil, msg, title, type, color, time)
end

---@param id number
BRIDGE.Func.payBill = function(id)
    print('payBill doesnt exist for OX')
end

--| Account |--
--@return table
BRIDGE.Func.getAccount = function(account)
    print('getAccount doesnt exist for OX')
end

--| Meta |--
--@return table|number|string
BRIDGE.Func.getMeta = function(meta)
    print('getMeta doesnt exist for OX')
end

--| Utility |--
--@return table
BRIDGE.Func.getVariables = function()
    print('getVariables doesnt exist for OX')
end