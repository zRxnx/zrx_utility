---@diagnostic disable: param-type-mismatch, duplicate-set-field
if GetResourceState('qb-core') == 'missing' then return end
QB = exports['qb-core']:GetCoreObject()
BRIDGE = {
    Framework = {
        type = 'qb',
        version = GetResourceMetadata('qb-core', 'version', 0),
        core = QB,
    },

    PLAYER_DROPPED = 'zrx_utility:bridge:playerDropped',
    PLAYER_LOADED = 'zrx_utility:bridge:playerLoaded',
    PLAYER_DEATH = 'zrx_utility:bridge:onPlayerDeath',
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
RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(player, reason)
    TriggerEvent('zrx_utility:bridge:playerDropped', player, reason)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function(player)
    TriggerEvent('zrx_utility:bridge:playerLoaded', player, QB:GetPlayer(player))
end)

RegisterNetEvent('QBCore:Server:OnJobUpdate', function(player, job)
    TriggerEvent('zrx_utility:bridge:setJob', player, job)
end)

RegisterNetEvent('QBCore:Server:OnPlayerDeath', function(data)
    TriggerEvent('zrx_utility:bridge:onPlayerDeath', source, data)
end)

--| Common |--
---@param item string
---@param cb function
BRIDGE.registerUsableItem = function(item, cb)
    QB.Functions.CreateUseableItem(item, cb)
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
    local xPlayer = QB.Functions.GetPlayer(player)
    local var, job2, md = xPlayer.PlayerData.charinfo, xPlayer.PlayerData.job, xPlayer.PlayerData.metadata

    local self = {}
    self.source = player
    self.player = player
    self.identifier = xPlayer.PlayerData.citizenid
    self.group = xPlayer.Functions.GetPermission()

    --self.maxWeight = 
    self.curWeight = xPlayer.PlayerData.GetTotalWeight
    self.inventory = xPlayer.PlayerData.LoadInventory
    self.loadout = self.inventory

    self.name = var.firstname .. ' ' .. var.lastname
    self.firstname = var.firstname
    self.lastname = var.lastname
    self.sex = var.gender
    self.height = var?.height
    self.dob = var.birthdate

    self.accounts = var.money

    self.job = {
        name = job2.name,
        label = job2.label,
        grade = job2.grade.level,
        grade_name = job2.grade.name,
        grade_salary = job2.grade.payment
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

    self.setMaxWeight = function(value)
        if type(value) ~= 'number' then
            return 'failed', 'Invalid data passed'
        end

        print('setMaxWeight doesnt exist for QB')

        return 'success'
    end

    self.getLicenses = function()
        return md.licenses
    end

    self.getBills = function()
        print('getBills doesnt exist for QB')
    end

    self.setJob = function(job, grade)
        if not job or not grade then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.SetJob(job, grade)

        return 'success'
    end

    self.addAccountMoney = function(account, amount, reason)
        if not account or not amount or not reason then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.AddMoney(account, amount)

        return 'success'
    end

    self.setAccountMoney = function(account, amount, reason)
        if not account or not amount or not reason then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.SetMoney(account, amount)

        return 'success'
    end

    self.removeAccountMoney = function(account, amount, reason)
        if not account or not amount or not reason then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.RemoveMoney(account, amount)

        return 'success'
    end

    self.getAccount = function(account)
        if not account then
            return 'fail', 'Invalid data passed'
        end

        return xPlayer.Functions.GetMoney(account)
    end

    self.addInventoryItem = function(item, count, metadata, slot, cb)
        if not item or not count then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.AddItem(item, count, slot, metadata)

        return 'success'
    end

    self.removeInventoryItem = function(item, count, metadata, slot, cb)
        if not item or not count then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.RemoveItem(item, count, slot, metadata)

        return 'success'
    end

    self.canCarryItem = function(item, count, metadata)
        if not item or not count then
            return 'fail', 'Invalid data passed'
        end

        print('canCarryItem doesnt exist for QB')

        return true
    end

    self.canSwapItem = function(sourceItem, sourceCount, targetItem, targetCount)
        if not sourceItem or not sourceCount or not targetItem or not targetCount then
            return 'fail', 'Invalid data passed'
        end

        print('canSwapItem doesnt exist for QB')

        return true
    end

    self.getItemCount = function(item, metadata, strict)
        if not item then
            return 'fail', 'Invalid data passed'
        end

        local output = xPlayer.Functions.GetItemByName(item)

        return output.count or output.amount or 0
    end

    self.hasItem = function(item, metadata, strict)
        if not item then
            return 'fail', 'Invalid data passed'
        end

        local output = xPlayer.Functions.GetItemByName(item)

        return output.count > 0 or output.amount > 0
    end

    self.clearMeta = function(meta)
        if not meta then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.SetMetaData(meta, nil)

        return 'success'
    end

    self.getMeta = function(meta, index)
        if not meta then
            return 'fail', 'Invalid data passed'
        end

        return xPlayer.Functions.GetMetaData(meta, index)
    end

    self.setMeta = function(meta, index, subIndex)
        if not meta then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.SetMetaData(meta, index)

        return 'success'
    end

    return self
end

--| Society Object |--
BRIDGE.getSocietyObject = function(job)
    local self = {}
    self.job = job
    self.money = self.getSocietyMoney()

    self.getSocietyMoney = function()
        return exports['qb-banking']:GetAccountBalance(job) or 0
    end

    self.addSocietyMoney = function(amount, reason)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        exports['qb-banking']:AddMoney(job, amount, reason)

        return 'success'
    end

    self.setSocietyMoney = function(amount, reason)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        exports['qb-banking']:RemoveMoney(job, exports['qb-banking']:GetAccountBalance(job), reason)
        exports['qb-banking']:AddMoney(job, amount, reason)

        return 'success'
    end

    self.removeSocietyMoney = function(amount, reason)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        exports['qb-banking']:RemoveMoney(job, amount, reason)

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
        return QB.Shared.Jobs[job] == true
    end

    self.getJobs = function()
        return QB.Shared.Jobs
    end

    return self
end

--| Vehicle Object |--
BRIDGE.getVehicleObject = function()
    local self = {}

    self.getAllVehicles = function() --owner plate
        local response = MYSQL:query_async('SELECT `citizenid`, `plate` FROM `player_vehicles`', {})
        local DATA = {}

        for k, data in pairs(response) do
            DATA[#DATA + 1] = {
                owner = data.citizenid,
                plate = data.plate
            }
        end

        return DATA
    end

    return self
end