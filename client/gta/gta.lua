---@param coords table
---@param text string
---@param r number
---@param g number
---@param b number
---@param scale number
CLIENT.DrawText3D = function(coords, text, r, g, b, scale)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    SetTextFont(0)
    SetTextScale(0, scale or 0.2)
    SetTextColour(r, g, b, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(0, 0)
    ClearDrawOrigin()
end

---@param coords table
---@param sprite number
---@param color number
---@param scale number
---@param text string
CLIENT.CreateBlip = function(coords, sprite, color, scale, text)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)

    return blip
end