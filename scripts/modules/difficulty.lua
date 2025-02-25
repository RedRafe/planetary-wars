local Config = require 'scripts.config'

local Difficulty = {}

---@class DifficultyData
---@field name string, key from Config.difficulty
---@field value number
---@field color Color
---@field localised_name? string|LocalisedString

local this = {
    name = nil,
    value = nil,
    color = nil,
    localised_name = nil,
}

---@param data table
---@field name? string
---@field value? number
---@field color? Colo
---@field localised_name? string|LocalisedString
---@return DifficultyData
local function parse_difficulty_data(data)
    local result = {
        name = 'custom',
        value = data.value or Config.difficulty.custom.value,
        color = data.color or Config.difficulty.custom.color,
        localised_name = data.localised_name,
    }

    for k, v in pairs(Config.difficulty) do
        if result.value == v.value then
            result.name = k
            result.localised_name = { 'difficulty.'..k }
        end
    end

    return result
end

Difficulty.get = function()
    return this
end

---@param data DifficultyData
Difficulty.set = function(data)
    data = parse_difficulty_data(data)

    this.name = data.name
    this.value = data.value
    this.color = data.color
    this.localised_name = data.localised_name
end

---@param name string
---@param value? number, override the preset value
Difficulty.set_from_name = function(name, value)
    local preset = Config.difficulty[name] or Config.difficulty.custom

    if value and value > 0 then
        preset.value = value or preset.value
    end

    Difficulty.set(preset)
end

bb.add(defines.events.on_map_init, function()
    Difficulty.set(Config.difficulty.normal)
end)

return Difficulty
