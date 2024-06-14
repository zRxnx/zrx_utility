---@diagnostic disable: duplicate-set-field
if GetResourceState('qb-core') == 'missing' then return end
QB = exports['qb-core']:GetCoreObject()
LOADED = false
BRIDGE = {
    Framework = {
        type = 'qb',
        version = GetResourceMetadata('qb-core', 'version', 0),
        core = QB,
    },

    PLAYER_LOADED = 'zrx_utility:bridge:playerLoaded',
    PLAYER_JOB = 'zrx_utility:bridge:setJob',
}

--| Handlers |--
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    LOADED = true
    TriggerEvent('zrx_utility:bridge:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    TriggerEvent('zrx_utility:bridge:setJob', job)
end)

---@diagnostic disable
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
    local xPlayer = QB.Functions.GetPlayerData()
    local var, job, md = xPlayer.playerData.charinfo, xPlayer.playerData.job, xPlayer.playerData.metadata
    local self = {}

    self.identifier = var.license
    self.group = var.permission

    --self.maxWeight = 
    self.curWeight = xPlayer.PlayerData.GetTotalWeight
    self.accounts = xPlayer.money
    self.inventory = xPlayer.PlayerData.LoadInventory
    self.loadout = self.inventory

    self.name = var.firstname .. ' ' .. var.lastname
    self.firstName = var.firstname
    self.lastName = var.lastname
    self.sex = var.gender == 0 and 'm' or 'f'
    self.height = var?.height
    self.dob = var.birthdate

    self.job = {
        name = job.name,
        label = job.label,
        grade = job.grade,
        grade_name = job.grade_name,
        grade_salary = job.grade_salary,
    }

    self.status = {
        hunger = {
            name = 'hunger',
            percent = md?.hunger
        },

        thirst = {
            name = 'thirst',
            percent = md?.thirst
        },
    }

    self.payBill = function(id)
        print('payBill doesnt exist for qb')
    end

    self.getAccount = function(account)
        for k, data in pairs(self.accounts) do
            if data.name == account then
                return {
                    name = data.type,
                    label = data.type,
                    money = data.amount,
                    round = true,
                }
            end
        end
    
        return {}
    end

    self.getMeta = function(meta)
        return md[meta]
    end

    return self
end