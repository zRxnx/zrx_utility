------------------------------------------------
--                                            --
--               NOT FINISHED YET             --
--                                            --
------------------------------------------------ 

---@diagnostic disable: param-type-mismatch, duplicate-set-field
if GetResourceState('qbx_core') == 'missing' then return end
QBX = exports.qbx_core
OX_INV = exports.ox_inventory
BRIDGE = {
    Framework = {
        type = 'qbx',
        version = GetResourceMetadata('qbx_core', 'version', 0),
        core = QBX,
    },

    PLAYER_DROPPED = 'zrx_utility:bridge:playerDropped',
    PLAYER_LOADED = 'zrx_utility:bridge:playerLoaded',
    PLAYER_DEATH = 'zrx_utility:bridge:onPlayerDeath',
    PLAYER_JOB = 'zrx_utility:bridge:setJob',
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
---@param item string
---@param cb function
BRIDGE.registerUsableItem = function(item, cb)
    QBX:CreateUseableItem(item, cb)
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
    local xPlayer = QBX:GetPlayer(player)
    local var, job, md = xPlayer.playerData.charinfo, xPlayer.playerData.job, xPlayer.playerData.metadata
    local INV = OX_INV:GetInventory(player)

    local self = {}
    self.source = player
    self.player = player
    self.identifier = var.license
    self.group = QBX:GetPermission(player)

    self.maxWeight = INV?.maxWeight
    self.curWeight = INV?.weight
    self.inventory = OX_INV:GetInventoryItems(player)
    self.loadout = self.inventory

    self.name = var.firstname .. ' ' .. var.lastname
    self.firstname = var.firstname
    self.lastname = var.lastname
    self.sex = var.gender
    self.height = 0
    self.dob = var.birthdate

    self.accounts = var.money

    self.job = {
        name = job.name,
        label = job.label,
        grade = job.grade.level,
        grade_name = job.grade.name,
        grade_salary = job.grade.payment
    }

    self.status = {
        hunger = {
            name = 'hunger',
            percent = md.hunger
        },

        thirst = {
            name = 'thirst',
            percent = md.thirst
        },
    }

    self.setMaxWeight = function(value)
        if type(value) ~= 'number' then
            return 'failed', 'Invalid data passed'
        end

        OX_INV:SetMaxWeight(player, value)

        return 'success'
    end

    self.getLicenses = function()
        print('getLicenses doesnt exist for QBOX')
    end

    self.getBills = function()
        print('getBills doesnt exist for QBOX')
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

        xPlayer.Functions.AddMoney(account, amount, reason)

        return 'success'
    end

    self.setAccountMoney = function(account, amount, reason)
        if not account or not amount or not reason then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.SetMoney(account, amount, reason)

        return 'success'
    end

    self.removeAccountMoney = function(account, amount, reason)
        if not account or not amount or not reason then
            return 'fail', 'Invalid data passed'
        end

        xPlayer.Functions.RemoveMoney(account, amount, reason)

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

        OX_INV:AddItem(player, item, count, metadata, slot, cb)

        return 'success'
    end

    self.removeInventoryItem = function(item, count, metadata, slot, cb)
        if not item or not count then
            return 'fail', 'Invalid data passed'
        end

        OX_INV:RemoveItem(player, item, count, metadata, slot)

        return 'success'
    end

    self.canCarryItem = function(item, count, metadata)
        if not item or not count then
            return 'fail', 'Invalid data passed'
        end

        return OX_INV:CanCarryItem(player, item, count, metadata) or false
    end

    self.canSwapItem = function(sourceItem, sourceCount, targetItem, targetCount)
        if not sourceItem or not sourceCount or not targetItem or not targetCount then
            return 'fail', 'Invalid data passed'
        end

        return OX_INV:CanSwapItem(player, sourceItem, sourceCount, targetItem, targetCount) or false
    end

    self.getItemCount = function(item, metadata, strict)
        if not item then
            return 'fail', 'Invalid data passed'
        end

        return OX_INV:GetItemCount(player, item, metadata, strict)
    end

    self.hasItem = function(item, metadata, strict)
        if not item then
            return 'fail', 'Invalid data passed'
        end

        return OX_INV:GetItemCount(player, item, metadata, strict) > 0
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

        return xPlayer.Functions.GetMeta(meta, index)
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
        return exports['Renewed-Banking']:getAccountMoney(job) or 0
    end

    self.addSocietyMoney = function(amount)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        exports.qbx_management:AddMoney(job, amount)

        return 'success'
    end

    self.setSocietyMoney = function(amount)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        exports.qbx_management:RemoveMoney(job, exports['Renewed-Banking']:getAccountMoney(job) or 0)
        exports.qbx_management:AddMoney(job, amount)

        return 'success'
    end

    self.removeSocietyMoney = function(amount)
        if not amount then
            return 'fail', 'Invalid data passed'
        end

        exports.qbx_management:RemoveMoney(job, amount)

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
        return exports['Renewed-Banking']:getAccountMoney(job) or 0
    end

    self.getJobs = function()
        return QBX:GetJobs()
    end

    return self
end

--| Vehicle Object |--
BRIDGE.getVehicleObject = function()
    local self = {}

    self.getAllVehicles = function()
        print('getAllVehicles doesnt exist for QBOX')
    end

    return self
end