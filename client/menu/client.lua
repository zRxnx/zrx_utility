local IsPauseMenuActive = IsPauseMenuActive

---@param menu table
---@param options table
---@param useContext boolean
---@param position string
CLIENT.CreateMenu = function(menu, options, useContext, position)
    if useContext then
        exports.ox_lib:registerContext({
            id = menu.id,
            title = menu.title,
            menu = menu.menu,
            canClose = menu.canClose,
            onExit = menu.onExit,
            onBack = menu.onBack,
            options = options
        })

        exports.ox_lib:showContext(menu.id)
    else
        local OPTIONS, FUNCTIONS, DISABLED, METADATA = {}, {}, {}, nil

        for i, data in ipairs(options) do
            if data.metadata then
                METADATA = {}
                for k, data2 in ipairs(data.metadata) do
                    METADATA[k] = ('%s: %s'):format(data2.label, data2.value)
                end
            end

            FUNCTIONS[i] = data.onSelect
            DISABLED[i] = not not data.disabled

            OPTIONS[i] = {
                label = data.title,
                values = METADATA,
                progress = data.progess,
                colorScheme = data.colorScheme,
                icon = data.icon,
                iconColor = data.iconColor,
                description = data.disabled == true and 'DISABLED | ' .. data.description or data.description,
                args = data.args,
            }
        end

        exports.ox_lib:registerMenu({
            id = menu.id,
            title = menu.title,
            position = position,
            canClose = menu.canClose,
            onClose = function(keyPressed)
                Wait(200)
                if menu.menu and not IsPauseMenuActive() then
                    exports.ox_lib:showMenu(menu.menu)

                    if menu.onBack then
                        menu.onBack()
                    end
                else
                    if menu.onExit then
                        menu.onExit()
                    end
                end
            end,
            options = OPTIONS
        }, function(selected, scrollIndex, args)
            if not DISABLED[selected] and FUNCTIONS[selected] then
                FUNCTIONS[selected](args)
            else
                exports.ox_lib:showMenu(menu.id)
            end
        end)

        exports.ox_lib:showMenu(menu.id)
    end
end