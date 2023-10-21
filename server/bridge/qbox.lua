---@diagnostic disable: duplicate-set-field
if GetResourceState('qbx_core') == 'missing' then return end
QBX = exports.qbx_core
OX_INV = exports.ox_inventory
BRIDGE = {
    Framework = {
        type = 'qbx',
        version = GetResourceMetadata('qbx_core', 'version', 0),
        core = QBX,
    },

    Func = {}
}

--| Handlers |--
RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(player, reason)
    TriggerEvent('zrx_utility:bridge:playerDropped', player, reason)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function(player)
    TriggerEvent('zrx_utility:bridge:playerLoaded', player, QBX:GetPlayer(player))
end)

RegisterNetEvent('QBCore:Server:OnJobUpdate', function(player, job)
    TriggerEvent('zrx_utility:bridge:setJob', player, job)
end)

RegisterNetEvent('QBCore:Server:OnPlayerDeath', function(data)
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
    QBX:CreateUseableItem(item, cb)
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
    print('getBills doesnt exist for QBOX')
end

---@param player number
--@return table
BRIDGE.Func.getLicenses = function(player)
    print('getLicenses doesnt exist for QBOX')
end

--| Job |--
---@param player number
---@param job string
---@param grade number
BRIDGE.Func.setJob = function(player, job, grade)
    QBX:GetPlayer(player).Functions.SetJob(job, grade)
end

---@param job string
---@param grade number
---@return boolean
BRIDGE.Func.doesJobExist = function(job, grade)
    local JOBS = QBX:GetJobs()

    for name, data in pairs(JOBS) do
        if name == job then
            for grade2, data2 in pairs(data.grades) do
                if grade2 == grade then
                    return true
                end
            end
        end
    end

    return false
end

---@return table
BRIDGE.Func.getJobs = function()
    return QBX:GetJobs()
end

--| Society |--
---@param job number
---@return number
BRIDGE.Func.getSocietyMoney = function(job)
    return exports['Renewed-Banking']:getAccountMoney(job) or 0
end

---@param job number
---@param amount number
BRIDGE.Func.addSocietyMoney = function(job, amount)
    exports.qbx_management:AddMoney(job, amount)
end

---@param job number
---@param amount number
BRIDGE.Func.setSocietyMoney = function(job, amount)
    exports.qbx_management:RemoveMoney(job, exports['Renewed-Banking']:getAccountMoney(job) or 0)
    exports.qbx_management:AddMoney(job, amount)
end

---@param job number
---@param amount number
BRIDGE.Func.removeSocietyMoney = function(job, amount)
    exports.qbx_management:RemoveMoney(job, amount)
end

--| Account |--
---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.addAccountMoney = function(player, account, amount, reason)
    QBX:GetPlayer(player).Functions.AddMoney(account, amount, reason)
end

---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.setAccountMoney = function(player, account, amount, reason)
    QBX:GetPlayer(player).Functions.SetMoney(account, amount, reason)
end

---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.removeAccountMoney = function(player, account, amount, reason)
    QBX:GetPlayer(player).Functions.RemoveMoney(account, amount, reason)
end

---@param player number
---@param account string
---@return table
BRIDGE.Func.getAccount = function(player, account)
    return QBX:GetPlayer(player).Functions.GetMoney(account)
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
    QBX:GetPlayer(player).Functions.SetMetaData(meta, nil)
end

---@param player number
---@param meta string
---@param index string
---@return table|number|string
BRIDGE.Func.getMeta = function(player, meta, index)
    return QBX:GetPlayer(player).Functions.GetMeta(meta, index)
end

---@param player number
---@param meta string
---@param index string
---@param subIndex string
BRIDGE.Func.setMeta = function(player, meta, index, subIndex)
    QBX:GetPlayer(player).Functions.SetMetaData(meta, index)
end

--| Utility |--
---@param player number
---@return table
BRIDGE.Func.getVariables = function(player)
    local xPlayer = QBX:GetPlayer(player)
    local var, job, md = xPlayer.playerData.charinfo, xPlayer.playerData.job, xPlayer.playerData.metadata
    local INV = OX_INV:GetInventory(player)

    return {
        player = player,
        identifier = var.license,
        group = QBX:GetPermission(player),

        maxWeight = INV?.maxWeight,
        curWeight = INV?.weight,

        name = var.firstname .. ' ' .. var.lastname,
        firstname = var.firstname,
        lastname = var.lastname,
        sex = var.gender,
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

        inventory = OX_INV:GetInventoryItems(player),
        loadout = {},
        accounts = var.money,
    }
end