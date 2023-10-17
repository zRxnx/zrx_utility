PLAYER_CACHE, PLAYERS = {}, {}
SERVER = {
    Func = {}
}

exports('GetUtility', function()
    return {
        Server = SERVER.Func,
        Shared = SHARED.Func,
        Bridge = BRIDGE.Func,
        Framework = BRIDGE.Framework,
    }
end)