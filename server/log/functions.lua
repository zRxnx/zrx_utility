---@diagnostic disable: duplicate-set-field
local GetPlayerName = GetPlayerName
local GetNumPlayerTokens = GetNumPlayerTokens
local GetPlayerGuid = GetPlayerGuid
local GetPlayerToken = GetPlayerToken
local PerformHttpRequest = PerformHttpRequest
local GetPlayerPing = GetPlayerPing
local GetResourceMetadata = GetResourceMetadata
local GetCurrentResourceName = GetCurrentResourceName
local GetPlayerIdentifierByType = GetPlayerIdentifierByType
local GetInvokingResource = GetInvokingResource
local GetPlayerEndpoint = GetPlayerEndpoint

---@param player number
---@return table
SERVER.GetPlayerCache = function(player)
    PLAYER_CACHE[player] = SERVER.GetPlayerData(player)

    return PLAYER_CACHE[player]
end

---@param player number
---@return table
SERVER.GetPlayerData = function(player)
    local playerString = tostring(player)
    local p = promise.new()
    local name = GetPlayerName(playerString)
    local numTokens = GetNumPlayerTokens(playerString)
    local guid = GetPlayerGuid(playerString)
    local fivem = (GetPlayerIdentifierByType(playerString, 'fivem') or 'NOT FOUND'):gsub('fivem:', '')
    local steam = (GetPlayerIdentifierByType(playerString, 'steam') or 'NOT FOUND'):gsub('steam:', '')
    local license = (GetPlayerIdentifierByType(playerString, 'license') or 'NOT FOUND'):gsub('license:', '')
    local license2 = (GetPlayerIdentifierByType(playerString, 'license2') or 'NOT FOUND'):gsub('license2:', '')
    local discord = (GetPlayerIdentifierByType(playerString, 'discord') or 'NOT FOUND'):gsub('discord:', '')
    local xbl = (GetPlayerIdentifierByType(playerString, 'xbl') or 'NOT FOUND'):gsub('xbl:', '')
    local liveid = (GetPlayerIdentifierByType(playerString, 'liveid') or 'NOT FOUND'):gsub('liveid:', '')
    local ip = GetPlayerEndpoint(playerString) or 'NOT FOUND'
    local country = 'NOT FOUND'
    local vpn = false
    local hwids = {}

    for i = 0, numTokens, 1 do
        hwids[#hwids + 1] = GetPlayerToken(playerString, i)
    end

    PerformHttpRequest(('http://ip-api.com/json/%s?fields=61439'):format(ip), function(_, result, _)
        if result then
            local data = json.decode(result)

            country = data.country or 'NOT FOUND'
            vpn = not not (data.hosting or data.proxy)

            p:resolve()
        end
    end)

    Citizen.Await(p)

    return {
        player = player,
        name = name,
        guid = guid,
        hwids = hwids,
        steam = steam,
        license = license,
        license2 = license2,
        fivem = fivem,
        xbl = xbl,
        ip = ip,
        discord = discord,
        liveid = liveid,
        country = country,
        vpn = vpn
    }
end

---@param player number
---@param title string
---@param message string
---@param webhook string
---@return nil
SERVER.DiscordLog = function(player, title, message, webhook)
    if webhook:len() <= 0 then return end
    local description = ('%s\n\n~~---------------------------------------------------------------------~~'):format(message)
    local fields = {}

    if not Webhook.Execlude.name then
        fields[#fields + 1] = {
            name = '`👤` **Player Name**',
            value = PLAYER_CACHE[player].name,
            inline = true,
        }
    end

    if not Webhook.Execlude.player then
        fields[#fields + 1] = {
            name = '`#️⃣` **Server ID**',
            value = PLAYER_CACHE[player].player,
            inline = true,
        }
    end

    if not Webhook.Execlude.ping then
        fields[#fields + 1] = {
            name = '`📶` **Player Ping**',
            value = ('%s ms'):format(GetPlayerPing(tostring(player))),
            inline = true,
        }
    end

    if not Webhook.Execlude.discord and PLAYER_CACHE[player].discord ~= 'NOT FOUND' then
        fields[#fields + 1] = {
            name = '`📌` **Discord ID**',
            value = PLAYER_CACHE[player].discord,
            inline = true,
        }
    end

    if not Webhook.Execlude.discord and PLAYER_CACHE[player].discord ~= 'NOT FOUND' then
        fields[#fields + 1] = {
            name = '`💎` **Discord Tag**',
            value = ('<@%s>'):format(PLAYER_CACHE[player].discord, PLAYER_CACHE[player].discord),
            inline = true,
        }
    end

    if not Webhook.Execlude.fivem and PLAYER_CACHE[player].fivem ~= 'NOT FOUND' then
        fields[#fields + 1] = {
            name = '`🟧` **FiveM ID**',
            value = PLAYER_CACHE[player].fivem,
            inline = true,
        }
    end

    if not Webhook.Execlude.license then
        fields[#fields + 1] = {
            name = '`📀` **License ID**',
            value = PLAYER_CACHE[player].license,
            inline = true,
        }
    end

    if not Webhook.Execlude.license2 then
        fields[#fields + 1] = {
            name = '`💿` **License2 ID**',
            value = PLAYER_CACHE[player].license2,
            inline = true,
        }
    end

    if not Webhook.Execlude.hwid then
        fields[#fields + 1] = {
            name = '`💻` **Hardware ID**',
            value = PLAYER_CACHE[player].hwids[1],
            inline = true,
        }
    end

    if not Webhook.Execlude.steam and PLAYER_CACHE[player].steam ~= 'NOT FOUND' then
        fields[#fields + 1] = {
            name = '`👾` **Steam ID - Hex**',
            value = PLAYER_CACHE[player].steam,
            inline = true,
        }
    end

    if not Webhook.Execlude.steam and PLAYER_CACHE[player].steam ~= 'NOT FOUND' then
        fields[#fields + 1] = {
            name = '`👾` **Steam ID - Decimal**',
            value = tonumber(PLAYER_CACHE[player].steam, 16),
            inline = true,
        }
    end

    if not Webhook.Execlude.xbl and PLAYER_CACHE[player].xbl ~= 'NOT FOUND' then
        fields[#fields + 1] = {
            name = '`🕹️` **XBOX Live ID**',
            value = PLAYER_CACHE[player].xbl,
            inline = true,
        }
    end

    if not Webhook.Execlude.guid then
        fields[#fields + 1] = {
            name = '`⚙️` **GUID**',
            value = PLAYER_CACHE[player].guid,
            inline = true,
        }
    end

    if not Webhook.Execlude.vpn then
        fields[#fields + 1] = {
            name = '`🤖` **VPN**',
            value = PLAYER_CACHE[player].vpn,
            inline = true,
        }
    end

    if not Webhook.Execlude.ip then
        fields[#fields + 1] = {
            name = '`🌐` **IP**',
            value = ('||%s||'):format(PLAYER_CACHE[player].ip),
            inline = true,
        }
    end

    if not Webhook.Execlude.country then
        fields[#fields + 1] = {
            name = '`🌍` **Country**',
            value = ('||%s||'):format(PLAYER_CACHE[player].country),
            inline = true,
        }
    end

    if not Webhook.Execlude.steam and PLAYER_CACHE[player].steam ~= 'NOT FOUND' then
        fields[#fields + 1] = {
            name = '`🔗` **Steam Profile**',
            value = ('https://steamcommunity.com/profiles/%s/'):format(tonumber(PLAYER_CACHE[player].steam, 16)),
            inline = false,
        }
    end

    if not Webhook.Execlude.xbl and PLAYER_CACHE[player].xbl ~= 'NOT FOUND' then
        fields[#fields + 1] = {
            name = '`🔗` **Xbox Profile**',
            value = ('https://account.xbox.com/de-at/profile?id=%s'):format(PLAYER_CACHE[player].xbl),
            inline = false,
        }
    end

    local embed = {
        {
            title = title,
            description = description,
            color = 255,
            footer = {
                text = ('Made by %s | %s'):format(GetResourceMetadata(GetCurrentResourceName(), 'author', 0), os.date()),
                icon_url = 'https://i.imgur.com/QOjklyr.png'
            },
            thumbnail = {
                url = 'https://i.imgur.com/QOjklyr.png',
            },
            author = {
                name = GetInvokingResource() or 'zrx_utility',
                url = ('https://github.com/zRxnx/%s'):format(GetInvokingResource() or 'zrx_utility'),
                icon_url = 'https://i.imgur.com/QOjklyr.png'
            },
            fields = fields,
        }
    }

    PerformHttpRequest(webhook, function() end, 'POST', json.encode({
        username = 'zrx_utility',
        embeds = embed,
        avatar_url = 'https://i.imgur.com/QOjklyr.png'
    }), {
        ['Content-Type'] = 'application/json'
    })
end