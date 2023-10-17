CLIENT.Func.RegisterKeyMappingCommand = function(name, desc, key, cb)
    RegisterCommand(name, cb)
    RegisterKeyMapping(name, desc, 'keyboard', key)
    TriggerEvent('chat:addSuggestion', ('/%s'):format(name), desc, {})
end