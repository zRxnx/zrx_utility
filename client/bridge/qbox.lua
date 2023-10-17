---@diagnostic disable: duplicate-set-field
if GetResourceState('qbx_core') == 'missing' then return end
QBX = exports.qbx_core
LOADED = false
BRIDGE = {
    Framework = {
        type = 'qbx',
        version = GetResourceMetadata('qbx_core', 'version', 0)
    },

    Func = {}
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

--| Account |--
---@return table
BRIDGE.Func.getAccount = function(account)
    for k, data in pairs(QBX:PlayerData().money) do
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

--| Meta |--
---@return table|number|string
BRIDGE.Func.getMeta = function(meta)
    return QBX:GetPlayerData().metadata[meta]
end

--| Utility |--
---@return table
BRIDGE.Func.getVariables = function()
    local xPlayer = QBX:GetPlayerData()
    local var, job, md = xPlayer.playerData.charinfo, xPlayer.playerData.job, xPlayer.playerData.metadata

    return {
        player = player,
        identifier = var.license,
        group = var.permission,

        maxWeight = OX_INV:GetPlayerMaxWeight(),
        curWeight = OX_INV:GetPlayerWeight(),

        name = var.firstname .. ' ' .. var.lastname,
        firstname = var.firstname,
        lastname = var.lastname,
        sex = var.gender == 0 and 'm' or 'f',
        height = 0,
        dob = var.birthdate,

        job = {
            name = job.name,
            label = job.label,
            grade = job.grade.level,
            grade_name = job.grade.name,
            grade_salary = job.grade.payment,
        },

        status = {
            hunger = {
                name = 'hunger',
                percent = md.hunger
            },

            thirst = {
                name = 'thirst',
                percent = md.thirst
            },
        },

        inventory = OX_INV:GetPlayerItems(),
        loadout = {},
        accounts = var.money,
    }
end