------------------------------------------------
--                                            --
--               NOT FINISHED YET             --
--                                            --
------------------------------------------------ 

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

    PLAYER_LOADED = 'zrx_utility:bridge:playerLoaded',
    PLAYER_JOB = 'zrx_utility:bridge:setJob',
}

CreateThread(function()
    Wait(5000)
    print([[

    W A R N I N G
    
    ESX IS THE ONLY MAINTAINED FRAMEWORK
    OTHER FRAMEWORKS WILL NOT 100% WORK AND WILL NOT GET SUPPORT
    
    ALSO OX_INVENTORY IS THE ONLY SUPPORTED INVENTORY BESIDE ESX DEFAULT ONE
    ]])
end)

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
BRIDGE.isPlayerDead = function()
    return Config.DeathCheck()
end

---@return boolean
BRIDGE.isPlayerLoaded = function()
    return LOADED
end

---@param msg string
---@param title string
---@param type string
---@param color number
---@param time number
BRIDGE.notification = function(msg, title, type, color, time)
    Config.Notification(nil, msg, title, type, color, time)
end

--| Player Object |--
BRIDGE.getPlayerObject = function()
    print('Doesnt exist for OX')
end