local GetGameTimer = GetGameTimer
SHARED = {}

local capital_letters = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' }
local low_letters = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' }
local numbers = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }

---@param table table
---@return string
SHARED.DumpTable = function(table, tab)
    tab = tab or 1

    if type(table) == 'table' then
        local line = '{\n'

        for k, data in pairs(table) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end

            for i = 1, tab, 1 do
				line = line .. '    '
			end

            line = line .. '[' .. k .. '] = ' .. SHARED.DumpTable(data, tab + 1) .. ',\n'
        end

        for i = 1, tab - 1, 1 do
			line = line .. '    '
		end

        return line .. '}'
    else
        return tostring(table)
    end
end

---@param length number
---@return string
SHARED.GeneratePassword = function(length)
    local pass, choice = '', 0

    math.randomseed(GetGameTimer())

    for _ = 1, length do
        choice = math.random(3)
        if choice == 1 then
            pass = pass .. capital_letters[math.random(#capital_letters)]
        elseif choice == 2 then
            pass = pass .. low_letters[math.random(#low_letters)]
        else
            pass = pass .. numbers[math.random(#numbers)]
        end
    end

    return pass
end

---@param tbl table
---@return table
SHARED.SortTableKeys = function(tbl)
    local keys = {}
    local sortedTable = {}

    for key, _ in pairs(tbl) do
        keys[#keys + 1] = key
    end

    table.sort(keys)

    for newIndex, oldKey in ipairs(keys) do
        sortedTable[newIndex] = tbl[oldKey]
    end

    return sortedTable
end

---@param number number
---@param decimal number
---@return number
SHARED.RoundNumber = function(number, decimal)
    local multiplier = 10 ^ decimal

    return math.floor(number * multiplier + 0.5) / multiplier
end

---@param string string
---@param sep string
---@return table
SHARED.StringSplit = function(string, sep)
    if not sep then
        sep = '%s'
    end

    local t, i = {}, 1

    for str in string:gmatch('([^' .. sep .. ']+)') do
        t[i] = str
        i += 1
    end

    return t
end

---@param string string
---@param find string
---@return boolean
SHARED.StartsWith = function(string, find)
    return string:sub(1, #find) == find
end

---@param value string
---@return string, number
SHARED.Trim = function(value)
    return value:gsub('^%s*(.-)%s*$', '%1')
end

---@param table table
---@return boolean
SHARED.IsTableEmpty = function(table)
    if not table then
        return true
    end

    for _ in pairs(table) do
        return false
    end

    return true
end