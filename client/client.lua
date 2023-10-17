CLIENT = {
    Func = {}
}

exports('GetUtility', function()
    return {
        Client = CLIENT.Func,
        Shared = SHARED.Func,
        Bridge = BRIDGE.Func,
        Framework = BRIDGE.Framework,
    }
end)