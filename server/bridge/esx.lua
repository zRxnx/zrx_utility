---@diagnostic disable: duplicate-set-field
if GetResourceState('es_extended') == 'missing' then return end
ESX = exports.es_extended:getSharedObject()
OX_INV = exports?.ox_inventory
MYSQL = exports.oxmysql
BRIDGE = {
    Framework = {
        type = 'esx',
        version = GetResourceMetadata('es_extended', 'version', 0),
        core = ESX,
    },

    Func = {},
    Enums = {
        PLAYER_DROPPED = 'zrx_utility:bridge:playerDropped',
        PLAYER_LOADED = 'zrx_utility:bridge:playerLoaded',
        PLAYER_DEATH = 'zrx_utility:bridge:onPlayerDeath',
        PLAYER_JOB = 'zrx_utility:bridge:setJob',
    }
}

--| Handlers |--
RegisterNetEvent('esx:playerDropped', function(player, reason)
    TriggerEvent('zrx_utility:bridge:playerDropped', player, reason)
end)

RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    TriggerEvent('zrx_utility:bridge:playerLoaded', player, xPlayer, isNew)
end)

RegisterNetEvent('esx:setJob', function(player, job, lastJob)
    TriggerEvent('zrx_utility:bridge:setJob', player, job, lastJob)
end)

RegisterNetEvent('esx:onPlayerDeath', function(data)
    TriggerEvent('zrx_utility:bridge:onPlayerDeath', source, data)
end)

--| Common |--
---@param player number
---@param weight number
BRIDGE.Func.setMaxWeight = function(player, weight)
    ESX.GetPlayerFromId(player).setMaxWeight(weight)
end

---@param item string
---@param cb function
BRIDGE.Func.registerUsableItem = function(item, cb)
    ESX.RegisterUsableItem(item, cb)
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
---@return table
BRIDGE.Func.getBills = function(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local results = MYSQL:query_async('SELECT * FROM `billing` WHERE `identifier` = ?', { xPlayer.identifier })
    local BILLS = {}

    for k, data in pairs(results) do
        BILLS[#BILLS + 1] = {
            id = data.id,
            label = data.label,
            amount = data.amount
        }
    end

    return BILLS
end

---@param player number
---@return table
BRIDGE.Func.getLicenses = function(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local results = MYSQL:query_async('SELECT * FROM `user_licenses` WHERE `owner` = ?', { xPlayer.identifier })
    local LICENSES = {}

    for k, data in pairs(results) do
        LICENSES[#LICENSES + 1] = {
            id = data.id,
            type = data.type,
        }
    end

    return LICENSES
end

--| Job |--
---@param player number
---@param job string
---@param grade number
BRIDGE.Func.setJob = function(player, job, grade)
    ESX.GetPlayerFromId(player).setJob(job, grade)
end

---@param job string
---@param grade number
---@return boolean
BRIDGE.Func.doesJobExist = function(job, grade)
    return ESX.DoesJobExist(job, grade)
end

---@return table
BRIDGE.Func.getJobs = function()
    return ESX.GetJobs()
end

--| Society |--
---@param job number
---@return table
BRIDGE.Func.getSocietyMoney = function(job)
    local p = promise.new()
    local money = 0

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(account)
        money = account.money
        p:resolve()
    end)

    Citizen.Await(p)

    return money
end

---@param job number
---@param amount number
BRIDGE.Func.addSocietyMoney = function(job, amount)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(account)
        account.addMoney(amount)
	end)
end

---@param job number
---@param amount number
BRIDGE.Func.setSocietyMoney = function(job, amount)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(account)
        account.setMoney(amount)
	end)
end

---@param job number
---@param amount number
BRIDGE.Func.removeSocietyMoney = function(job, amount)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(account)
        account.removeMoney(amount)
	end)
end

--| Account |--
---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.addAccountMoney = function(player, account, amount, reason)
    if Config.Framework.ESX.inventory == 'ox_inventory' and Config.Framework.ESX.inventoryAccounts[account] then
        OX_INV:AddItem(player, account, amount)
    elseif Config.Framework.ESX.inventory == 'qs-inventory' and Config.Framework.ESX.inventoryAccounts[account] then
        exports['qs-inventory']:AddItem(player, account, amount)
    else
        ESX.GetPlayerFromId(player).addAccountMoney(account, amount, reason)
    end
end

---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.setAccountMoney = function(player, account, amount, reason)
    if Config.Framework.ESX.inventory == 'ox_inventory' and Config.Framework.ESX.inventoryAccounts[account] then
        OX_INV:RemoveItem(player, account, OX_INV:GetItemCount(player, account))
        OX_INV:AddItem(player, account, amount)
    elseif Config.Framework.ESX.inventory == 'qs-inventory' and Config.Framework.ESX.inventoryAccounts[account] then
        exports['qs-inventory']:RemoveItem(player, account, exports['qs-inventory']:GetItemTotalAmount(player, account))
        exports['qs-inventory']:AddItem(player, account, amount)
    else
        ESX.GetPlayerFromId(player).setAccountMoney(account, amount, reason)
    end
end

---@param player number
---@param account string
---@param amount number
---@param reason string
BRIDGE.Func.removeAccountMoney = function(player, account, amount, reason)
    if Config.Framework.ESX.inventory == 'ox_inventory' and Config.Framework.ESX.inventoryAccounts[account] then
        OX_INV:RemoveItem(player, account, amount)
    elseif Config.Framework.ESX.inventory == 'qs-inventory' and Config.Framework.ESX.inventoryAccounts[account] then
        exports['qs-inventory']:RemoveItem(player, account, amount)
    else
        ESX.GetPlayerFromId(player).removeAccountMoney(account, amount, reason)
    end
end

---@param player number
---@param account string
---@return table
BRIDGE.Func.getAccount = function(player, account)
    return ESX.GetPlayerFromId(player).getAccount(account)
end

--| Inventory |--
---@param player number
---@param item string
---@param count number
---@param metadata table
---@param slot number
---@param cb function
BRIDGE.Func.addInventoryItem = function(player, item, count, metadata, slot, cb)
    if Config.Framework.ESX.inventory == 'ox_inventory' then
        OX_INV:AddItem(player, item, count, metadata, slot, cb)
    elseif Config.Framework.ESX.inventory == 'qs-inventory' then
        exports['qs-inventory']:AddItem(player, item, count, slot, metadata)
    else
        ESX.GetPlayerFromId(player).addInventoryItem(item, count)
    end
end

---@param player number
---@param item string
---@param count number
---@param metadata table
---@param slot number
BRIDGE.Func.removeInventoryItem = function(player, item, count, metadata, slot)
    if Config.Framework.ESX.inventory == 'ox_inventory' then
        OX_INV:RemoveItem(player, item, count, metadata, slot)
    elseif Config.Framework.ESX.inventory == 'qs-inventory' then
        exports['qs-inventory']:RemoveItem(player, item, count, slot, metadata)
    else
        ESX.GetPlayerFromId(player).removeInventoryItem(item, count)
    end
end

---@param player number
---@param item string
---@param count number
---@param metadata table
---@return boolean
BRIDGE.Func.canCarryItem = function(player, item, count, metadata)
    if Config.Framework.ESX.inventory == 'ox_inventory' then
        return OX_INV:CanCarryItem(player, item, count, metadata) or false
    elseif Config.Framework.ESX.inventory == 'qs-inventory' then
        return exports['qs-inventory']:CanCarryItem(player, item, count)
    end

    return ESX.GetPlayerFromId(player).canCarryItem(item, count)
end

---@param player number
---@param sourceItem string
---@param sourceCount number
---@param targetItem string
---@param targetCount number
---@return boolean
BRIDGE.Func.canSwapItem = function(player, sourceItem, sourceCount, targetItem, targetCount)
    if Config.Framework.ESX.inventory == 'ox_inventory' then
        return OX_INV:CanSwapItem(player, sourceItem, sourceCount, targetItem, targetCount) or false
    elseif Config.Framework.ESX.inventory == 'qs-inventory' then
        print('canSwapItem doesnt exist for QS')
        return false
    end

    return ESX.GetPlayerFromId(player).canSwapItem(sourceItem, sourceCount, targetItem, targetCount)
end

BRIDGE.Func.getItemCount = function(player, item, metadata, strict)
    if Config.Framework.ESX.inventory == 'ox_inventory' then
        return OX_INV:GetItemCount(player, item, metadata, strict)
    elseif Config.Framework.ESX.inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetItemTotalAmount(player, item)
    end

    return ESX.GetPlayerFromId(player).getInventoryItem(item).count
end

---@param player number
---@param item string
---@param metadata table
---@param strict boolean
---@return boolean
BRIDGE.Func.hasItem = function(player, item, metadata, strict)
    if Config.Framework.ESX.inventory == 'ox_inventory' then
        return OX_INV:GetItemCount(player, item, metadata, strict) > 0
    elseif Config.Framework.ESX.inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetItemTotalAmount(player, item) > 0
    end

    return ESX.GetPlayerFromId(player).hasItem(item) == true
end

--| Meta |--
---@param player number
---@param meta string
BRIDGE.Func.clearMeta = function(player, meta)
    ESX.GetPlayerFromId(player).clearMeta(meta)
end

---@param player number
---@param meta string
---@param index string
---@return table|number|string
BRIDGE.Func.getMeta = function(player, meta, index)
    return ESX.GetPlayerFromId(player).getMeta(meta, index)
end

---@param player number
---@param meta string
---@param index string
---@param subIndex string
BRIDGE.Func.setMeta = function(player, meta, index, subIndex)
    ESX.GetPlayerFromId(player).setMeta(meta, index, subIndex)
end

--| Utility |--
---@param player number
---@return table
BRIDGE.Func.getVariables = function(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local var, job = xPlayer.variables, xPlayer.job
    local status = {}
    local inventory, loadout = {}, {}

    if Config.Framework.ESX.inventory == 'default' then
        inventory = xPlayer.inventory
        loadout = xPlayer.loadout
    elseif Config.Framework.ESX.inventory == 'ox_inventory' then
        inventory = OX_INV:GetInventoryItems(player) or {}
        loadout = {}
    end

    if var?.status then
        for i, data in pairs(var.status) do
            status[data.name] = {
                name = data.name,
                percent = data.percent,
                value = data.val
            }
        end
    end

    return {
        player = player,
        identifier = xPlayer.identifier,
        group = xPlayer.group,

        maxWeight = xPlayer.maxWeight,
        curWeight = xPlayer.weight,

        name = var.firstName .. ' ' .. var.lastName,
        firstname = var.firstName,
        lastname = var.lastName,
        sex = var.sex,
        height = var.height,
        dob = var.dateofbirth,

        job = {
            name = job.name,
            label = job.label,
            grade = job.grade,
            grade_name = job.grade_name,
            grade_label = job.grade_label,
            grade_salary = job.grade_salary,
        },

        status = status,
        inventory = inventory,
        loadout = loadout,
        accounts = xPlayer.accounts,
        addonAccounts = var.addonAccounts,
    }
end