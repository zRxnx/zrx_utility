------------------------------------------------
--                                            --
--               NOT FINISHED YET             --
--                                            --
------------------------------------------------ 

---@diagnostic disable: param-type-mismatch, duplicate-set-field
if GetResourceState('ox_core') == 'missing' then return end
OX = exports.ox_core
OX_INV = exports.ox_inventory
BRIDGE = {
    Framework = {
        type = 'ox',
        version = GetResourceMetadata('ox_core', 'version', 0),
        core = OX,
    },

    PLAYER_DROPPED = 'zrx_utility:bridge:playerDropped',
    PLAYER_LOADED = 'zrx_utility:bridge:playerLoaded',
    PLAYER_DEATH = 'zrx_utility:bridge:onPlayerDeath',
    PLAYER_JOB = 'zrx_utility:bridge:setJob',
}

--| Handlers |--
RegisterNetEvent('ox:playerLogout', function(player, userid, charid)
    TriggerEvent('zrx_utility:bridge:playerDropped', player)
end)

RegisterNetEvent('ox:playerLoaded', function(player, userid, charid)
    TriggerEvent('zrx_utility:bridge:playerLoaded', player)
end)

RegisterNetEvent('ox:setJob', function(player, job, lastJob) --| Doesnt exist
    TriggerEvent('zrx_utility:bridge:setJob', player, job, lastJob)
end)

RegisterNetEvent('ox:onPlayerDeath', function(data)
    TriggerEvent('zrx_utility:bridge:onPlayerDeath', source, data)
end)

--| Common |--
---@param item string
---@param cb function
BRIDGE.registerUsableItem = function(item, cb)
    print('registerUsableItem doesnt exist for OX')
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
    local self = {}

    self.setMaxWeight = function(value)
        OX_INV:SetMaxWeight(player, value)
    end

    self.getLicenses = function()
        print('getLicenses doesnt exist for OX')
    end

    self.getBills = function()
        print('getBills doesnt exist for OX')
    end

    self.setJob = function(job, grade)
        print('setJob doesnt exist for OX')
    end

    self.addAccountMoney = function(account, amount, reason)
        print('addAccountMoney doesnt exist for OX')
    end

    self.setAccountMoney = function(account, amount, reason)
        print('setAccountMoney doesnt exist for OX')
    end

    self.removeAccountMoney = function(account, amount, reason)
        print('removeAccountMoney doesnt exist for OX')
    end

    self.getAccount = function(account)
        print('getAccount doesnt exist for OX')
    end

    self.addInventoryItem = function(item, count, metadata, slot, cb)
        OX_INV:AddItem(player, item, count, metadata, slot, cb)
    end

    self.removeInventoryItem = function(item, count, metadata, slot, cb)
        OX_INV:RemoveItem(player, item, count, metadata, slot)
    end

    self.canCarryItem = function(item, count, metadata)
        return OX_INV:CanCarryItem(player, item, count, metadata) or false
    end

    self.canSwapItem = function(sourceItem, sourceCount, targetItem, targetCount)
        return OX_INV:CanSwapItem(player, sourceItem, sourceCount, targetItem, targetCount) or false
    end

    self.getItemCount = function(item, metadata, strict)
        return OX_INV:GetItemCount(player, item, metadata, strict)
    end

    self.hasItem = function(item, metadata, strict)
        return OX_INV:GetItemCount(player, item, metadata, strict) > 0
    end

    self.clearMeta = function(meta)
        OX.GetPlayer(player).set(meta, nil)
    end

    self.getMeta = function(meta, index)
        return OX.GetPlayer(player).get(meta)
    end

    self.setMeta = function(meta, index, subIndex, replicated)
        OX.GetPlayer(player).set(meta, index, replicated)
    end

    return self
end

--| Society Object |--
BRIDGE.getSocietyObject = function(job)
    local self = {}
    self.job = job
    self.money = self.getSocietyMoney()

    self.getSocietyMoney = function()
        print('getSocietyMoney doesnt exist for OX')
    end

    self.addSocietyMoney = function(amount)
        print('addSocietyMoney doesnt exist for OX')
    end

    self.setSocietyMoney = function(amount)
        print('setSocietyMoney doesnt exist for OX')
    end

    self.removeSocietyMoney = function(amount)
        print('removeSocietyMoney doesnt exist for OX')
    end

    return self
end

--| Job Object |--
BRIDGE.getJobObject = function(job, grade)
    local self = {}
    self.job = job
    self.grade = grade

    self.doesJobExist = function()
        print('doesJobExist doesnt exist for OX')
    end

    self.getJobs = function()
        print('getJobs doesnt exist for OX')
    end

    return self
end