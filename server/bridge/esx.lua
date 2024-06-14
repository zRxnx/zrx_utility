---@diagnostic disable: param-type-mismatch, duplicate-set-field
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

    PLAYER_DROPPED = 'zrx_utility:bridge:playerDropped',
    PLAYER_LOADED = 'zrx_utility:bridge:playerLoaded',
    PLAYER_DEATH = 'zrx_utility:bridge:onPlayerDeath',
    PLAYER_JOB = 'zrx_utility:bridge:setJob',
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
---@param item string
---@param cb function
BRIDGE.registerUsableItem = function(item, cb)
    ESX.RegisterUsableItem(item, cb)
end

---@param player number
BRIDGE.isPlayerDead = function(player)
    return Config.DeathCheck(player)
end

---@param player number
---@param msg string
---@param title string
---@param type string
---@param color number
---@param time number
BRIDGE.notification = function(player, msg, title, type, color, time)
    Config.Notification(player, msg, title, type, color, time)
end


--| Player Object |--
---@param player number
BRIDGE.getPlayerObject = function(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local var, job2 = xPlayer.variables, xPlayer.job
    local status = {}
    local inventory, loadout = {}, {}

    if Config.Framework.ESX.inventory == 'default' then
        inventory = xPlayer.inventory
        loadout = xPlayer.loadout
    elseif Config.Framework.ESX.inventory == 'ox_inventory' then
        inventory = OX_INV:GetInventoryItems(player) or {}
        loadout = inventory
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

    local self = {}
    self.source = player
    self.player = player
    self.identifier = xPlayer.identifier
    self.group = xPlayer.group

    self.maxWeight = xPlayer.maxWeight
    self.curWeight = xPlayer.weight
    self.inventory = inventory
    self.loadout = loadout

    self.name = var.firstName .. ' ' .. var.lastName
    self.firstName = var.firstName
    self.lastName = var.lastName
    self.sex = var.sex
    self.height = var.height
    self.dob = var.dateofbirth
    self.status = status

    self.accounts = xPlayer.accounts
    self.addonAccounts = var.addonAccounts

    self.job = {
        name = job2.name,
        label = job2.label,
        grade = job2.grade,
        grade_name = job2.grade_name,
        grade_label = job2.grade_label,
        grade_salary = job2.grade_salary,
    }

    self.setMaxWeight = function(value)
        if type(value) ~= 'number' then
            return 'failed', 'Invalid data passed'
        end

        xPlayer.setMaxWeight(value)

        return 'success'
    end

    self.getLicenses = function()
        local results = MYSQL:query_async('SELECT * FROM `user_licenses` WHERE `owner` = ?', { self.identifier })
        local LICENSES = {}

        for k, data in pairs(results) do
            LICENSES[#LICENSES + 1] = {
                id = data.id,
                type = data.type,
            }
        end

        if #LICENSES > 0 then
            return LICENSES
        else
            return 'fail', 'No data saved'
        end
    end

    self.getBills = function()
        local results = MYSQL:query_async('SELECT * FROM `billing` WHERE `identifier` = ?', { self.identifier })
        local BILLS = {}

        for k, data in pairs(results) do
            BILLS[#BILLS + 1] = {
                id = data.id,
                label = data.label,
                amount = data.amount
            }
        end

        if #BILLS > 0 then
            return BILLS
        else
            return 'fail', 'No data saved'
        end
    end

    self.setJob = function(job, grade)
        if not job or not grade then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.setJob(job, grade)

        return 'success'
    end

    self.addAccountMoney = function(account, amount, reason)
        if not account or not amount or not reason then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' and Config.Framework.ESX.inventoryAccounts[account] then
            OX_INV:AddItem(self.player, account, amount)
        elseif Config.Framework.ESX.inventory == 'qs-inventory' and Config.Framework.ESX.inventoryAccounts[account] then
            exports['qs-inventory']:AddItem(self.player, account, amount)
        else
            xPlayer.addAccountMoney(account, amount, reason)
        end

        return 'success'
    end

    self.setAccountMoney = function(account, amount, reason)
        if not account or not amount or not reason then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' and Config.Framework.ESX.inventoryAccounts[account] then
            OX_INV:RemoveItem(self.player, account, OX_INV:GetItemCount(self.player, account))
            OX_INV:AddItem(self.player, account, amount)
        elseif Config.Framework.ESX.inventory == 'qs-inventory' and Config.Framework.ESX.inventoryAccounts[account] then
            exports['qs-inventory']:RemoveItem(self.player, account, exports['qs-inventory']:GetItemTotalAmount(self.player, account))
            exports['qs-inventory']:AddItem(self.player, account, amount)
        else
            xPlayer.setAccountMoney(account, amount, reason)
        end

        return 'success'
    end

    self.removeAccountMoney = function(account, amount, reason)
        if not account or not amount or not reason then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' and Config.Framework.ESX.inventoryAccounts[account] then
            OX_INV:RemoveItem(self.player, account, amount)
        elseif Config.Framework.ESX.inventory == 'qs-inventory' and Config.Framework.ESX.inventoryAccounts[account] then
            exports['qs-inventory']:RemoveItem(self.player, account, amount)
        else
            xPlayer.removeAccountMoney(account, amount, reason)
        end

        return 'success'
    end

    self.getAccount = function(account)
        if not account then
            return 'fail', 'Invalid data passed'
        end

        return xPlayer.getAccount(account)
    end

    self.addInventoryItem = function(item, count, metadata, slot, cb)
        if not item or not count then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' then
            OX_INV:AddItem(self.player, item, count, metadata, slot, cb)
        elseif Config.Framework.ESX.inventory == 'qs-inventory' then
            exports['qs-inventory']:AddItem(self.player, item, count, slot, metadata)
        else
            xPlayer.addInventoryItem(item, count)
        end

        return 'success'
    end

    self.removeInventoryItem = function(item, count, metadata, slot, cb)
        if not item or not count then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' then
            OX_INV:RemoveItem(self.player, item, count, metadata, slot)
        elseif Config.Framework.ESX.inventory == 'qs-inventory' then
            exports['qs-inventory']:RemoveItem(self.player, item, count, slot, metadata)
        else
            xPlayer.removeInventoryItem(item, count)
        end

        return 'success'
    end

    self.canCarryItem = function(item, count, metadata)
        if not item or not count then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' then
            return OX_INV:CanCarryItem(self.player, item, count, metadata) or false
        elseif Config.Framework.ESX.inventory == 'qs-inventory' then
            return exports['qs-inventory']:CanCarryItem(self.player, item, count)
        end

        return xPlayer.canCarryItem(item, count)
    end

    self.canSwapItem = function(sourceItem, sourceCount, targetItem, targetCount)
        if not sourceItem or not sourceCount or not targetItem or not targetCount then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' then
            return OX_INV:CanSwapItem(self.player, sourceItem, sourceCount, targetItem, targetCount) or false
        elseif Config.Framework.ESX.inventory == 'qs-inventory' then
            print('canSwapItem doesnt exist for QS')
            return false
        end

        return xPlayer.canSwapItem(sourceItem, sourceCount, targetItem, targetCount)
    end

    self.getItemCount = function(item, metadata, strict)
        if not item then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' then
            return OX_INV:GetItemCount(self.player, item, metadata, strict)
        elseif Config.Framework.ESX.inventory == 'qs-inventory' then
            return exports['qs-inventory']:GetItemTotalAmount(self.player, item)
        end

        return xPlayer.getInventoryItem(item).count
    end

    self.hasItem = function(item, metadata, strict)
        if not item then
            return 'fail', 'Invalid data passed'
        end

        if Config.Framework.ESX.inventory == 'ox_inventory' then
            return OX_INV:GetItemCount(self.player, item, metadata, strict) > 0
        elseif Config.Framework.ESX.inventory == 'qs-inventory' then
            return exports['qs-inventory']:GetItemTotalAmount(self.player, item) > 0
        end

        return xPlayer.hasItem(item) == true
    end

    self.clearMeta = function(meta)
        if not meta then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.clearMeta(meta)

        return 'success'
    end

    self.getMeta = function(meta, index)
        if not meta then
            return 'fail', 'Invalid data passed'
        end

        return xPlayer.getMeta(meta, index)
    end

    self.setMeta = function(meta, index, subIndex)
        if not meta then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.setMeta(meta, index, subIndex)

        return 'success'
    end

    return self
end

--| Society Object |--
BRIDGE.getSocietyObject = function(job)
    local self = {}
    self.job = job

    self.getSocietyMoney = function()
        local p = promise.new()
        local money = 0

        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. self.job, function(account)
            money = account.money
            p:resolve()
        end)

        Citizen.Await(p)

        return money
    end

    self.addSocietyMoney = function(amount)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. self.job, function(account)
            account.addMoney(amount)
        end)

        return 'success'
    end

    self.setSocietyMoney = function(amount)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. self.job, function(account)
            account.setMoney(amount)
        end)

        return 'success'
    end

    self.removeSocietyMoney = function(amount)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. self.job, function(account)
            account.removeMoney(amount)
        end)

        return 'success'
    end

    return self
end

--| Job Object |--
BRIDGE.getJobObject = function(job, grade)
    local self = {}
    self.job = job
    self.grade = grade

    self.doesJobExist = function()
        return ESX.DoesJobExist(self.job, self.grade)
    end

    self.getJobs = function()
        return ESX.GetJobs()
    end

    return self
end

--| Vehicle Object |--
BRIDGE.getVehicleObject = function()
    local self = {}

    self.getAllVehicles = function()
        return MYSQL:query_async('SELECT `owner`, `plate` FROM `owned_vehicles`', {})
    end

    self.spawnVehicle = function(model, coords, plate)
        local vehicleNet
        local p = promise.new()

        ESX.OneSync.SpawnVehicle(model, vector3(coords.x, coords.y, coords.z), coords[4], {}, function(netId)
            vehicleNet = netId
            p:resolve()
        end)

        Citizen.Await(p)

        if not vehicleNet then
            return print('Failed to create vehicle')
        end

        local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)

        if plate then
            SetVehicleNumberPlateText(vehicle, plate)
        end

        return vehicleNet, vehicle
    end

    return self
end