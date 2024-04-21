---@diagnostic disable: duplicate-set-field, undefined-field
if GetResourceState('es_extended') == 'missing' then return end
ESX = exports.es_extended:getSharedObject()
BRIDGE = {
    Framework = {
        type = 'esx',
        version = GetResourceMetadata('es_extended', 'version', 0),
        core = ESX,
    },

    PLAYER_LOADED = 'zrx_utility:bridge:playerLoaded',
    PLAYER_JOB = 'zrx_utility:bridge:setJob',
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
BRIDGE.isPlayerDead = function()
    return Config.DeathCheck()
end

---@return boolean
BRIDGE.isPlayerLoaded = function()
    return ESX.IsPlayerLoaded()
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
    local xPlayer = ESX.GetPlayerData()
    local job = xPlayer.job
    local self = {}

    self.identifier = xPlayer.identifier
    self.group = xPlayer.group

    self.maxWeight = xPlayer.maxWeight
    self.curWeight = xPlayer.weight
    self.inventory = xPlayer.inventory
    self.loadout = xPlayer.loadout
    self.accounts = xPlayer.accounts

    self.name = xPlayer.firstName .. ' ' .. xPlayer.lastName
    self.firstName = xPlayer.firstName
    self.lastName = xPlayer.lastName
    self.sex = xPlayer.sex
    self.height = xPlayer.height
    self.dob = xPlayer.dateofbirth

    self.job = {
        name = job.name,
        label = job.label,
        grade = job.grade,
        grade_name = job.grade_name,
        grade_label = job.grade_label,
        grade_salary = job.grade_salary,
    }

    self.payBill = function(id)
        ESX.TriggerServerCallback('esx_billing:payBill', function()
        end, id)
    end

    self.getAccount = function(account)
        for k, data in pairs(self.accounts) do
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

    self.getMeta = function(meta)
        return ESX.GetPlayerData().metadata[meta]
    end

    return self
end