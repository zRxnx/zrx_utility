---@diagnostic disable: duplicate-set-field
if GetResourceState('es_extended') == 'missing' then return end
ESX = exports.es_extended:getSharedObject()
BRIDGE = {
    Framework = {
        type = 'esx',
        version = GetResourceMetadata('es_extended', 'version', 0)
    },

    Func = {}
}

--| Handlers |--
RegisterNetEvent('esx:playerLoaded', function(xPlayer, isNew)
    TriggerEvent('zrx_utility:bridge:playerLoaded', xPlayer, isNew)
end)

RegisterNetEvent('esx:setJob', function(job, lastJob)
    TriggerEvent('zrx_utility:bridge:setJob', job, lastJob)
end)

--| Common |--
---@return boolean
BRIDGE.Func.isPlayerDead = function()
    return Config.DeathCheck()
end

---@return boolean
BRIDGE.Func.isPlayerLoaded = function()
    return ESX.IsPlayerLoaded()
end

---@param msg string
---@param title string
---@param type string
---@param color number
---@param time number
BRIDGE.Func.notification = function(msg, title, type, color, time)
    Config.Notification(nil, msg, title, type, color, time)
end

--| Account |--
---@return table
BRIDGE.Func.getAccount = function(account)
    for k, data in pairs(ESX.PlayerData().accounts) do
        if data.name == account then
            return {
                name = data.name,
                label = data.label,
                money = data.money,
                round = data.round,
            }
        end
    end

    return {}
end

--| Meta |--
---@return table|string|number
BRIDGE.Func.getMeta = function(meta)
    return ESX.GetPlayerData().metadata[meta]
end

--| Utility |--
---@return table
BRIDGE.Func.getVariables = function()
    local xPlayer = ESX.GetPlayerData()
    local job = xPlayer.job

    return {
        player = player,
        identifier = xPlayer.identifier,
        group = xPlayer.group,

        maxWeight = xPlayer.maxWeight,
        curWeight = xPlayer.weight,

        name = xPlayer.firstName .. ' ' .. xPlayer.lastName,
        firstname = xPlayer.firstName,
        lastname = xPlayer.lastName,
        sex = xPlayer.sex,
        height = xPlayer.height,
        dob = xPlayer.dateofbirth,

        job = {
            name = job.name,
            label = job.label,
            grade = job.grade,
            grade_name = job.grade_name,
            grade_label = job.grade_label,
            grade_salary = job.grade_salary,
        },

        inventory = xPlayer.inventory,
        loadout = xPlayer.loadout,
        accounts = xPlayer.accounts,
    }
end