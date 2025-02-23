local emojis = require 'graphics.emojis.list'
local subgroups = require 'graphics.emojis.subgroups'

local function localised_name(name)
    -- Replace underscores with spaces
    local result = name:gsub('_', ' ')

    -- Capitalize the first character
    return result:gsub('^%l', string.upper)
end

local function create_emoji_signal(name)
    local signal = table.deepcopy(data.raw['virtual-signal']['signal-everything'])

    signal.type = 'virtual-signal'
    signal.name = 'emoji-' .. name
    signal.localised_name = localised_name(name)
    signal.icon = string.format('__planetary-wars__/graphics/emojis/icons/%s.png', name)
    signal.icon_size = 64
    signal.icon_mipmaps = 1
    signal.subgroup = 'emojis-'..(subgroups[name] or 'other')
    signal.order = 'emoji-' .. name

    return signal
end

data:extend({
    {
        type = 'item-group',
        name = 'emojis',
        order = 'z-emojis',
        icon = '__planetary-wars__/graphics/emojis/tab-emoji-signals.png',
        icon_size = 128,
        icon_mipmaps = 1,
    },
    {
        type = 'item-subgroup',
        name = 'emojis-smileys',
        group = 'emojis',
        order = 'a',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-people',
        group = 'emojis',
        order = 'b',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-nature',
        group = 'emojis',
        order = 'c',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-food',
        group = 'emojis',
        order = 'd',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-activity',
        group = 'emojis',
        order = 'e',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-travel',
        group = 'emojis',
        order = 'f',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-objects',
        group = 'emojis',
        order = 'g',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-symbols',
        group = 'emojis',
        order = 'h',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-flags',
        group = 'emojis',
        order = 'i',
    },
    {
        type = 'item-subgroup',
        name = 'emojis-other',
        group = 'emojis',
        order = 'j',
    },
})

for _, name in pairs(emojis) do
    data:extend({ create_emoji_signal(name) })
end
