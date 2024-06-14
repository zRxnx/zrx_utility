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

--| Not finished yet
RegisterConsoleListener(function(channel, message)
    if not channel == 'citizen-server-impl' then
        return
    end
end)