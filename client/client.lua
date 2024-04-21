CLIENT = {}

exports('GetUtility', function()
    return {
        Client = CLIENT,
        Shared = SHARED,
        Bridge = BRIDGE,
        Framework = BRIDGE.Framework,
    }
end)