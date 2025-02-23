local emojis = require 'graphics.emojis.list'
local subgroups = require 'graphics.emojis.subgroups'

function localised_name(input)
    -- Replace underscores with spaces
    local result = input:gsub('_', ' ')
    
    -- Capitalize the first character
    result = result:gsub('^%l', string.upper)
    return result
end

function create_emoji_signal(name)
    local p = table.deepcopy(data.raw['virtual-signal']['signal-everything'])
    p.type = 'virtual-signal'
    p.name = 'emoji-' .. name
    p.localised_name = localised_name(name)
    p.icon = string.format('__planetary-wars__/graphics/emojis/icons/%s.png', name)
    p.icon_size = 64
    p.icon_mipmaps = 1
    p.subgroup = 'emojis-'..(subgroups[name] or 'other')
    p.order = 'emoji-' .. name
    data:extend({ p })

    if not subgroups[name] then 
        bb.print(name)
    end
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
    create_emoji_signal(name)
end
