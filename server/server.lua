PLAYER_CACHE, PLAYERS = {}, {}
SERVER = {}

exports('GetUtility', function()
    return {
        Server = SERVER,
        Shared = SHARED,
        Bridge = BRIDGE,
        Framework = BRIDGE.Framework,
    }
end)