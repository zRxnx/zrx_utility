RegisterNetEvent('zrx_utility:bridge:playerLoaded', function(player)
    if not GetInvokingResource() then return end

    PLAYER_CACHE[player] = SERVER.GetPlayerData(player)
    PLAYERS[player] = true
end)

AddEventHandler('playerDropped', function()
    PLAYERS[source] = nil
end)

---@diagnostic disable: param-type-mismatch
---@diagnostic disable: need-check-nil
---@diagnostic disable: cast-local-type
CreateThread(function()
    for i, player in pairs(GetPlayers()) do
        player = tonumber(player)
        PLAYER_CACHE[player] = SERVER.GetPlayerData(player)
        PLAYERS[player] = true
    end
end)