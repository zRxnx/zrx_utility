---@param name string
---@param desc string
---@param key string
---@param cb function
CLIENT.RegisterKeyMappingCommand = function(name, desc, key, cb)
    RegisterCommand(name, cb)
    RegisterKeyMapping(name, desc, 'keyboard', key)
    TriggerEvent('chat:addSuggestion', ('/%s'):format(name), desc, {})
end