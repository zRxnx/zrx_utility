---@diagnostic disable: duplicate-set-field
CreateThread(function()
    SERVER.Func.CheckVersion('zrx_utility')
end)

---@param resource string
SERVER.Func.GetRepoInformations = function(resource)
    local p = promise.new()
    local ver, url

    PerformHttpRequest(('https://api.github.com/repos/zRxnx/%s/releases/latest'):format(resource), function(err, response)
        if err == 200 then
            local data = json.decode(response)

            ver = data.tag_name or 'INVALID RESPONSE'
            url = data.html_url or 'INVALID RESPONSE'

            p:resolve()
        end
    end, 'GET')

    Citizen.Await(p)

    return ver, url
end

---@param resource string
SERVER.Func.CheckVersion = function(resource)
    local repoVersion, repoURL = SERVER.Func.GetRepoInformations(resource)
    local curVersion = GetResourceMetadata(resource, 'version', 0)

    if repoVersion == 'INVALID RESPONSE' or repoURL == 'INVALID RESPONSE' then
        print(('^0[^1ERROR^0] Failed to fetch version for %s'):format(resource))
    elseif curVersion ~= repoVersion then
        print(('^0[^3WARNING^0] %s is ^1NOT ^0up to date!'):format(resource))
        print(('^0[^3WARNING^0] Your Version: ^2%s^0'):format(curVersion))
        print(('^0[^3WARNING^0] Latest Version: ^2%s^0'):format(repoVersion))
        print(('^0[^3WARNING^0] Get the latest Version from: ^2%s^0'):format(repoURL))
    else
        print(('^0[^2INFO^0] %s is up to date! (^2%s^0)'):format(resource, curVersion))
    end

    SERVER.Func.CheckResource(resource)
end

---@param resource string
SERVER.Func.CheckResource = function(resource)
    CreateThread(function()
        SetTimeout(1000 * 60 * 60, function()
            SERVER.Func.CheckVersion(resource)
        end)
    end)
end