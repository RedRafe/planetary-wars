local sounds = require '__base__.prototypes.entity.sounds'
local hit_effects = require '__base__.prototypes.entity.hit-effects'

local biter_run_animation = biterrunanimation -- luacheck: ignore 113
local biter_attack_animation = biterattackanimation -- luacheck: ignore 113
local biter_water_reflection = biter_water_reflection -- luacheck: ignore 113
local spitter_alternative_attacking_animation_sequence = spitter_alternative_attacking_animation_sequence -- luacheck: ignore 113
local spitter_attack_parameters = spitter_attack_parameters -- luacheck: ignore 113
local spitter_run_animation = spitterrunanimation -- luacheck: ignore 113
local spitter_water_reflection = spitter_water_reflection -- luacheck: ignore 113

local function get_params(tbl, tier)
    local params = {}

    for k, _ in pairs(tbl) do
        params[k] = tbl[k][tier]
    end

    return params
end

local function make_unit_melee_ammo_type(damage_value)
    return {
        target_type = 'entity',
        action = {
            type = 'direct',
            action_delivery = {
                type = 'instant',
                target_effects = {
                    type = 'damage',
                    damage = { amount = damage_value , type = 'physical' }
                }
            }
        }
    }
end

local tiers = {
    --'small',     --    0% Small Biter / Small Spitter
    --'medium',    --   20% Medium Biter / Medium Spitter
    --'big',       --   50% Big Biter / Big Spitter
    --'behemoth',  --   90% Behemoth Biter / Behemoth Spitter
    'overlord',    --  100% Overlord Biter / Overlord Spitter
    'adept',       --  150% Adept Biter / Adept Spitter
    'champion',    --  200% Champion Biter / Champion Spitter
    'warlord',     --  250% Warlord Biter / Warlord Spitter
    'conqueror',   --  300% Conqueror Biter / Conqueror Spitter
    'elder',       --  350% Elder Biter / Elder Spitter
    'arch',        --  400% Arch Biter / Arch Spitter
    'sovereign',   --  450% Sovereign Biter / Sovereign Spitter
    'tyrant',      --  500% Tyrant Biter / Tyrant Spitter
    'ascendant',   --  550% Ascendant Biter / Ascendant Spitter
    'primordial',  --  600% Primordial Biter / Primordial Spitter
    'titan',       --  650% Titan Biter / Titan Spitter
    'colossus',    --  700% Colossus Biter / Colossus Spitter
    'mythic',      --  750% Mythic Biter / Mythic Spitter
    'legendary',   --  800% Legendary Biter / Legendary Spitter
    'epic',        --  850% Epic Biter / Epic Spitter
    'abyssal',     --  900% Abyssal Biter / Abyssal Spitter
    'eldritch',    --  950% Eldritch Biter / Eldritch Spitter
    'leviathan',   -- 1000% Leviathan Biter / Leviathan Spitter
}

local tints = {
    { 032, 179, 255 },    -- Bright Cyan
    { 153, 255, 179 },    -- Light Mint
    { 166, 229, 002 },    -- Bright Lime
    { 156, 229, 002 },    -- Lime Green
    { 225, 225, 075 },    -- Lemon Yellow
    { 153, 032, 125 },    -- Dark Magenta
    { 125, 075, 153 },    -- Plum
    { 102, 075, 179 },    -- Steel Blue
    { 000, 127, 005 },    -- Deep Green
    { 000, 117, 005 },    -- Rich Green
    { 255, 032, 001 },    -- Bright Red
    { 244, 032, 002 },    -- Scarlet
    { 102, 102, 153 },    -- Dusty Gray
    { 153, 153, 102 },    -- Olive
    { 153, 128, 085 },    -- Tan
    { 179, 076, 076 },    -- Brick Red
    { 255, 179, 102 },    -- Soft Orange
    { 255, 165, 025 },    -- Warm Amber
    { 255, 204, 051 },    -- Bright Gold
}

local scales = {
    1.2,  -- Overlord
    1.3,  -- Adept
    1.4,  -- Champion
    1.5,  -- Warlord
    1.6,  -- Conqueror
    1.7,  -- Elder
    1.8,  -- Arch
    1.9,  -- Sovereign
    2.0,  -- Tyrant
    2.1,  -- Ascendant
    2.2,  -- Primordial
    2.3,  -- Titan
    2.4,  -- Colossus
    2.5,  -- Mythic
    2.6,  -- Legendary
    2.7,  -- Epic
    2.8,  -- Abyssal
    2.9,  -- Eldritch
    3.0,  -- Leviathan
}

local parents = {
    'medium',
    'big',
    'behemoth',
    'small',
    'medium',
    'big',
    'behemoth',
    'small',
    'medium',
    'big',
    'behemoth',
    'small',
    'medium',
    'big',
    'behemoth',
    'small',
    'medium',
    'big',
    'behemoth',
}

local biters = {
    health = {
        4500,      -- Overlord
        6750,      -- Adept
        10125,     -- Champion
        15188,     -- Warlord
        22782,     -- Conqueror
        34173,     -- Elder
        51260,     -- Arch
        76890,     -- Sovereign
        115335,    -- Tyrant
        173003,    -- Ascendant
        259505,    -- Primordial
        389258,    -- Titan
        583887,    -- Colossus
        875831,    -- Mythic
        1313747,   -- Legendary
        1970621,   -- Epic
        2955932,   -- Abyssal
        4433898,   -- Eldritch
        6650847,   -- Leviathan
    },
    resistances = {
        { physical = 14, explosion = 12 },  -- Overlord
        { physical = 16, explosion = 14 },  -- Adept
        { physical = 18, explosion = 16 },  -- Champion
        { physical = 20, explosion = 18 },  -- Warlord
        { physical = 22, explosion = 20 },  -- Conqueror
        { physical = 24, explosion = 22 },  -- Elder
        { physical = 26, explosion = 25 },  -- Arch
        { physical = 28, explosion = 28 },  -- Sovereign
        { physical = 30, explosion = 30 },  -- Tyrant
        { physical = 32, explosion = 32 },  -- Ascendant
        { physical = 34, explosion = 34 },  -- Primordial
        { physical = 36, explosion = 36 },  -- Titan
        { physical = 38, explosion = 38 },  -- Colossus
        { physical = 40, explosion = 40 },  -- Mythic
        { physical = 42, explosion = 42 },  -- Legendary
        { physical = 44, explosion = 44 },  -- Epic
        { physical = 46, explosion = 46 },  -- Abyssal
        { physical = 48, explosion = 48 },  -- Eldritch
        { physical = 50, explosion = 50 },  -- Leviathan
    },
    healing_per_tick = {
        0.2,       -- Overlord
        0.25,      -- Adept
        0.3,       -- Champion
        0.4,       -- Warlord
        0.5,       -- Conqueror
        0.6,       -- Elder
        0.7,       -- Arch
        0.8,       -- Sovereign
        0.9,       -- Tyrant
        1.0,       -- Ascendant
        1.1,       -- Primordial
        1.2,       -- Titan
        1.3,       -- Colossus
        1.4,       -- Mythic
        1.5,       -- Legendary
        1.6,       -- Epic
        1.7,       -- Abyssal
        1.8,       -- Eldritch
        1.9,       -- Leviathan
    },
    collision_box = {
        {{-0.5, -0.5}, {0.5, 0.5}},  -- Overlord
        {{-0.5, -0.5}, {0.5, 0.5}},  -- Adept
        {{-0.5, -0.5}, {0.5, 0.5}},  -- Champion
        {{-0.5, -0.5}, {0.5, 0.5}},  -- Warlord
        {{-0.6, -0.6}, {0.6, 0.6}},  -- Conqueror
        {{-0.6, -0.6}, {0.6, 0.6}},  -- Elder
        {{-0.6, -0.6}, {0.6, 0.6}},  -- Arch
        {{-0.6, -0.6}, {0.6, 0.6}},  -- Sovereign
        {{-0.7, -0.7}, {0.7, 0.7}},  -- Tyrant
        {{-0.7, -0.7}, {0.7, 0.7}},  -- Ascendant
        {{-0.7, -0.7}, {0.7, 0.7}},  -- Primordial
        {{-0.8, -0.8}, {0.8, 0.8}},  -- Titan
        {{-0.8, -0.8}, {0.8, 0.8}},  -- Colossus
        {{-0.9, -0.9}, {0.9, 0.9}},  -- Mythic
        {{-1.0, -1.0}, {1.0, 1.0}},  -- Legendary
        {{-1.0, -1.0}, {1.0, 1.0}},  -- Epic
        {{-1.1, -1.1}, {1.1, 1.1}},  -- Abyssal
        {{-1.2, -1.2}, {1.2, 1.2}},  -- Eldritch
        {{-1.3, -1.3}, {1.3, 1.3}},  -- Leviathan
    },
    selection_box = {
        {{-1.0, -1.5}, {1.0, 0.5}},  -- Overlord
        {{-1.0, -1.5}, {1.0, 0.5}},  -- Adept
        {{-1.0, -1.5}, {1.0, 0.5}},  -- Champion
        {{-1.0, -1.5}, {1.0, 0.5}},  -- Warlord
        {{-1.2, -1.8}, {1.2, 0.6}},  -- Conqueror
        {{-1.2, -1.8}, {1.2, 0.6}},  -- Elder
        {{-1.2, -1.8}, {1.2, 0.6}},  -- Arch
        {{-1.2, -1.8}, {1.2, 0.6}},  -- Sovereign
        {{-1.5, -2.0}, {1.5, 0.7}},  -- Tyrant
        {{-1.5, -2.0}, {1.5, 0.7}},  -- Ascendant
        {{-1.5, -2.0}, {1.5, 0.8}},  -- Primordial
        {{-1.5, -2.0}, {1.5, 0.8}},  -- Titan
        {{-1.7, -2.5}, {1.7, 0.9}},  -- Colossus
        {{-1.7, -2.5}, {1.7, 0.9}},  -- Mythic
        {{-1.7, -2.5}, {1.7, 0.9}},  -- Legendary
        {{-1.8, -2.5}, {1.8, 1.0}},  -- Epic
        {{-2.0, -3.0}, {2.0, 1.1}},  -- Abyssal
        {{-2.0, -3.0}, {2.0, 1.1}},  -- Eldritch
        {{-2.5, -3.5}, {2.5, 1.5}},  -- Leviathan
    },
    attack_parameters = {
        { range = 2.0, cooldown = 45, cooldown_deviation = 0.1,  damage =  150 }, -- Overlord
        { range = 2.5, cooldown = 40, cooldown_deviation = 0.1,  damage =  180 }, -- Adept
        { range = 2.5, cooldown = 35, cooldown_deviation = 0.1,  damage =  200 }, -- Champion
        { range = 3.0, cooldown = 30, cooldown_deviation = 0.1,  damage =  300 }, -- Warlord
        { range = 3.0, cooldown = 25, cooldown_deviation = 0.1,  damage =  400 }, -- Conqueror
        { range = 3.5, cooldown = 20, cooldown_deviation = 0.1,  damage =  500 }, -- Elder
        { range = 4.0, cooldown = 18, cooldown_deviation = 0.1,  damage =  600 }, -- Arch
        { range = 4.0, cooldown = 16, cooldown_deviation = 0.1,  damage =  700 }, -- Sovereign
        { range = 4.5, cooldown = 14, cooldown_deviation = 0.1,  damage =  800 }, -- Tyrant
        { range = 5.0, cooldown = 12, cooldown_deviation = 0.1,  damage =  900 }, -- Ascendant
        { range = 5.5, cooldown = 10, cooldown_deviation = 0.05, damage = 1000 }, -- Primordial
        { range = 6.0, cooldown = 8,  cooldown_deviation = 0.05, damage = 1200 }, -- Titan
        { range = 6.5, cooldown = 7,  cooldown_deviation = 0.05, damage = 1500 }, -- Colossus
        { range = 7.0, cooldown = 6,  cooldown_deviation = 0.05, damage = 1800 }, -- Mythic
        { range = 7.5, cooldown = 5,  cooldown_deviation = 0.05, damage = 2000 }, -- Legendary
        { range = 8.0, cooldown = 4,  cooldown_deviation = 0.05, damage = 2200 }, -- Epic
        { range = 8.5, cooldown = 3,  cooldown_deviation = 0.05, damage = 2500 }, -- Abyssal
        { range = 9.0, cooldown = 2,  cooldown_deviation = 0.05, damage = 3000 }, -- Eldritch
        { range = 9.5, cooldown = 1,  cooldown_deviation = 0.05, damage = 3500 }, -- Leviathan
    },
    movement_speed = {
        0.32,      -- Overlord
        0.34,      -- Adept
        0.35,      -- Champion
        0.36,      -- Warlord
        0.37,      -- Conqueror
        0.38,      -- Elder
        0.39,      -- Arch
        0.40,      -- Sovereign
        0.41,      -- Tyrant
        0.42,      -- Ascendant
        0.43,      -- Primordial
        0.44,      -- Titan
        0.45,      -- Colossus
        0.46,      -- Mythic
        0.47,      -- Legendary
        0.48,      -- Epic
        0.49,      -- Abyssal
        0.50,      -- Eldritch
        0.51,      -- Leviathan
    },
    distance_per_frame = {
        0.35,      -- Overlord
        0.36,      -- Adept
        0.37,      -- Champion
        0.38,      -- Warlord
        0.39,      -- Conqueror
        0.40,      -- Elder
        0.41,      -- Arch
        0.42,      -- Sovereign
        0.43,      -- Tyrant
        0.44,      -- Ascendant
        0.45,      -- Primordial
        0.46,      -- Titan
        0.47,      -- Colossus
        0.48,      -- Mythic
        0.49,      -- Legendary
        0.50,      -- Epic
        0.51,      -- Abyssal
        0.52,      -- Eldritch
        0.53,      -- Leviathan
    },
    absorptions_to_join_attack = {
        500,       -- Overlord
        700,       -- Adept
        900,       -- Champion
        1100,      -- Warlord
        1300,      -- Conqueror
        1500,      -- Elder
        1700,      -- Arch
        2000,      -- Sovereign
        2300,      -- Tyrant
        2600,      -- Ascendant
        2900,      -- Primordial
        3200,      -- Titan
        3500,      -- Colossus
        4000,      -- Mythic
        4500,      -- Legendary
        5000,      -- Epic
        6000,      -- Abyssal
        7000,      -- Eldritch
        8000,      -- Leviathan
    },
}

local spitters = {
    health = {
        2500,      -- Overlord
        3750,      -- Adept
        5500,      -- Champion
        8000,      -- Warlord
        12000,     -- Conqueror
        18000,     -- Elder
        27000,     -- Arch
        40500,     -- Sovereign
        60000,     -- Tyrant
        90000,     -- Ascendant
        135000,    -- Primordial
        200000,    -- Titan
        300000,    -- Colossus
        450000,    -- Mythic
        675000,    -- Legendary
        1012500,   -- Epic
        1518750,   -- Abyssal
        2278125,   -- Eldritch
        3417187,   -- Leviathan
    },
    resistances = {
        { explosion = 35 },  -- Overlord
        { explosion = 40 },  -- Adept
        { explosion = 45 },  -- Champion
        { explosion = 50 },  -- Warlord
        { explosion = 55 },  -- Conqueror
        { explosion = 60 },  -- Elder
        { explosion = 65 },  -- Arch
        { explosion = 70 },  -- Sovereign
        { explosion = 75 },  -- Tyrant
        { explosion = 80 },  -- Ascendant
        { explosion = 85 },  -- Primordial
        { explosion = 90 },  -- Titan
        { explosion = 95 },  -- Colossus
        { explosion = 100 }, -- Mythic
        { explosion = 105 }, -- Legendary
        { explosion = 110 }, -- Epic
        { explosion = 115 }, -- Abyssal
        { explosion = 120 }, -- Eldritch
        { explosion = 125 }, -- Leviathan
    },
    healing_per_tick = {
        0.15,   -- Overlord
        0.2,    -- Adept
        0.25,   -- Champion
        0.3,    -- Warlord
        0.35,   -- Conqueror
        0.4,    -- Elder
        0.5,    -- Arch
        0.6,    -- Sovereign
        0.7,    -- Tyrant
        0.8,    -- Ascendant
        0.9,    -- Primordial
        1.0,    -- Titan
        1.2,    -- Colossus
        1.5,    -- Mythic
        2.0,    -- Legendary
        2.5,    -- Epic
        3.0,    -- Abyssal
        4.0,    -- Eldritch
        5.0,    -- Leviathan
    },
    collision_box = {
        {{-0.4, -0.4}, {0.4, 0.4}},  -- Overlord
        {{-0.5, -0.5}, {0.5, 0.5}},  -- Adept
        {{-0.5, -0.5}, {0.5, 0.5}},  -- Champion
        {{-0.5, -0.5}, {0.5, 0.5}},  -- Warlord
        {{-0.6, -0.6}, {0.6, 0.6}},  -- Conqueror
        {{-0.6, -0.6}, {0.6, 0.6}},  -- Elder
        {{-0.7, -0.7}, {0.7, 0.7}},  -- Arch
        {{-0.7, -0.7}, {0.7, 0.7}},  -- Sovereign
        {{-0.8, -0.8}, {0.8, 0.8}},  -- Tyrant
        {{-0.8, -0.8}, {0.8, 0.8}},  -- Ascendant
        {{-0.9, -0.9}, {0.9, 0.9}},  -- Primordial
        {{-0.9, -0.9}, {0.9, 0.9}},  -- Titan
        {{-1.0, -1.0}, {1.0, 1.0}},  -- Colossus
        {{-1.0, -1.0}, {1.0, 1.0}},  -- Mythic
        {{-1.0, -1.0}, {1.0, 1.0}},  -- Legendary
        {{-1.1, -1.1}, {1.1, 1.1}},  -- Epic
        {{-1.2, -1.2}, {1.2, 1.2}},  -- Abyssal
        {{-1.5, -1.5}, {1.5, 1.5}},  -- Eldritch
        {{-2.0, -2.0}, {2.0, 2.0}},  -- Leviathan
    },
    selection_box = {
        {{-0.7, -1.0}, {0.7, 1.0}},  -- Overlord
        {{-0.7, -1.0}, {0.7, 1.0}},  -- Adept
        {{-0.8, -1.2}, {0.8, 1.2}},  -- Champion
        {{-0.8, -1.2}, {0.8, 1.2}},  -- Warlord
        {{-0.9, -1.5}, {0.9, 1.5}},  -- Conqueror
        {{-0.9, -1.5}, {0.9, 1.5}},  -- Elder
        {{-1.0, -2.0}, {1.0, 2.0}},  -- Arch
        {{-1.0, -2.0}, {1.0, 2.0}},  -- Sovereign
        {{-1.0, -2.5}, {1.0, 2.5}},  -- Tyrant
        {{-1.0, -2.5}, {1.0, 2.5}},  -- Ascendant
        {{-1.1, -3.0}, {1.1, 3.0}},  -- Primordial
        {{-1.1, -3.0}, {1.1, 3.0}},  -- Titan
        {{-1.5, -4.0}, {1.5, 4.0}},  -- Colossus
        {{-1.5, -4.0}, {1.5, 4.0}},  -- Mythic
        {{-1.5, -4.5}, {1.5, 4.5}},  -- Legendary
        {{-1.6, -5.0}, {1.6, 5.0}},  -- Epic
        {{-1.7, -5.5}, {1.7, 5.5}},  -- Abyssal
        {{-1.8, -6.0}, {1.8, 6.0}},  -- Eldritch
        {{-2.0, -6.5}, {2.0, 6.5}},  -- Leviathan
    },
    attack_parameters = {
        { range =  3.0, cooldown = 40, cooldown_deviation = 0.10, damage =  100 },  -- Overlord
        { range =  3.5, cooldown = 35, cooldown_deviation = 0.10, damage =  130 },  -- Adept
        { range =  4.0, cooldown = 30, cooldown_deviation = 0.10, damage =  160 },  -- Champion
        { range =  4.5, cooldown = 25, cooldown_deviation = 0.10, damage =  200 },  -- Warlord
        { range =  5.0, cooldown = 22, cooldown_deviation = 0.10, damage =  250 },  -- Conqueror
        { range =  5.5, cooldown = 20, cooldown_deviation = 0.10, damage =  300 },  -- Elder
        { range =  6.0, cooldown = 18, cooldown_deviation = 0.10, damage =  350 },  -- Arch
        { range =  6.5, cooldown = 16, cooldown_deviation = 0.10, damage =  400 },  -- Sovereign
        { range =  7.0, cooldown = 14, cooldown_deviation = 0.10, damage =  500 },  -- Tyrant
        { range =  7.5, cooldown = 12, cooldown_deviation = 0.10, damage =  600 },  -- Ascendant
        { range =  8.0, cooldown = 10, cooldown_deviation = 0.05, damage =  700 },  -- Primordial
        { range =  8.5, cooldown =  8, cooldown_deviation = 0.05, damage =  800 },  -- Titan
        { range =  9.0, cooldown =  7, cooldown_deviation = 0.05, damage =  900 },  -- Colossus
        { range =  9.5, cooldown =  6, cooldown_deviation = 0.05, damage = 1100 },  -- Mythic
        { range = 10.0, cooldown =  5, cooldown_deviation = 0.05, damage = 1200 },  -- Legendary
        { range = 10.5, cooldown =  4, cooldown_deviation = 0.05, damage = 1400 },  -- Epic
        { range = 11.0, cooldown =  3, cooldown_deviation = 0.05, damage = 1600 },  -- Abyssal
        { range = 11.5, cooldown =  2, cooldown_deviation = 0.05, damage = 1800 },  -- Eldritch
        { range = 12.0, cooldown =  1, cooldown_deviation = 0.05, damage = 2000 },  -- Leviathan
    },
    movement_speed = {
        0.145,  -- Overlord
        0.140,  -- Adept
        0.135,  -- Champion
        0.130,  -- Warlord
        0.125,  -- Conqueror
        0.120,  -- Elder
        0.115,  -- Arch
        0.110,  -- Sovereign
        0.105,  -- Tyrant
        0.100,  -- Ascendant
        0.095,  -- Primordial
        0.090,  -- Titan
        0.085,  -- Colossus
        0.080,  -- Mythic
        0.075,  -- Legendary
        0.070,  -- Epic
        0.065,  -- Abyssal
        0.060,  -- Eldritch
        0.055,  -- Leviathan
    },
    distance_per_frame = {
        0.1,    -- Overlord
        0.12,   -- Adept
        0.14,   -- Champion
        0.16,   -- Warlord
        0.18,   -- Conqueror
        0.20,   -- Elder
        0.22,   -- Arch
        0.24,   -- Sovereign
        0.26,   -- Tyrant
        0.28,   -- Ascendant
        0.30,   -- Primordial
        0.32,   -- Titan
        0.34,   -- Colossus
        0.36,   -- Mythic
        0.38,   -- Legendary
        0.40,   -- Epic
        0.45,   -- Abyssal
        0.50,   -- Eldritch
        0.55,   -- Leviathan
    },
    absorptions_to_join_attack = {
        400,    -- Overlord
        600,    -- Adept
        900,    -- Champion
        1200,   -- Warlord
        1700,   -- Conqueror
        2500,   -- Elder
        3500,   -- Arch
        5000,   -- Sovereign
        7500,   -- Tyrant
        10000,  -- Ascendant
        15000,  -- Primordial
        20000,  -- Titan
        30000,  -- Colossus
        45000,  -- Mythic
        67500,  -- Legendary
        101250,  -- Epic
        151875,  -- Abyssal
        227812,  -- Eldritch
        341718,  -- Leviathan
    },
}

for i, tier in pairs(tiers) do
    local b = get_params(biters, i)
    local s = get_params(spitters, i)

    data:extend{
        {
            type = 'unit',
            name = tier..'-biter',
            icons = {
                { icon = '__base__/graphics/icons/'..(parents[i] or 'small')..'-biter.png' },
                { icon = '__base__/graphics/icons/'..(parents[i] or 'small')..'-biter.png', tint = tints[i] },
            },
            flags = { 'placeable-player', 'placeable-enemy', 'placeable-off-grid', 'not-repairable', 'breaths-air' },
            max_health = b.health or 15,
            order = 'b-a-d-'..(i+10),
            subgroup = 'enemies',
            --factoriopedia_simulation = simulations.factoriopedia_small_biter,
            resistances = {
                { type = 'physical', decrease = b.resistances.physical, percent = 10 },
                { type = 'explosion', decrease = b.resistances.explosion, percent = 10 },
            },
            healing_per_tick = b.healing_per_tick or 0.01,
            collision_box = b.collision_box or {{-0.2, -0.2}, {0.2, 0.2}},
            selection_box = b.selection_box or {{-0.4, -0.7}, {0.4, 0.4}},
            damaged_trigger_effect = hit_effects.biter(),
            attack_parameters = {
                type = 'projectile',
                range = b.attack_parameters.range or 0.5,
                cooldown = b.attack_parameters.cooldown or 35,
                cooldown_deviation = b.attack_parameters.cooldown_deviation or 0.15,
                ammo_category = 'melee',
                ammo_type = make_unit_melee_ammo_type(b.attack_parameters.damage or 7),
                sound = sounds.biter_roars(0.35),
                animation = biter_attack_animation(scales[i], tints[i], tints[i]),
                range_mode = 'bounding-box-to-bounding-box',
            },
            impact_category = 'organic',
            vision_distance = 30,
            movement_speed = b.movement_speed or 0.2,
            distance_per_frame = b.distance_per_frame or 0.125,
            absorptions_to_join_attack = { pollution = b.absorptions_to_join_attack or 4 },
            distraction_cooldown = 300,
            min_pursue_time = 10 * 60,
            max_pursue_distance = 50,
            corpse = (parents[i] or 'small')..'-biter-corpse',
            dying_explosion = (parents[i] or 'small')..'-biter-die',
            dying_sound = sounds.biter_dying(0.5),
            working_sound = sounds.biter_calls(0.4, 0.75),
            run_animation = biter_run_animation(scales[i], tints[i], tints[i]),
            running_sound_animation_positions = { 2 },
            walking_sound = sounds.biter_walk(0, 0.3),
            ai_settings = { destroy_when_commands_fail = true, allow_try_return_to_spawner = true },
            water_reflection = biter_water_reflection(scales[i]),
        },
        {
            type = 'unit',
            name = tier..'-spitter',
            icons = {
                { icon = '__base__/graphics/icons/'..(parents[i] or 'small')..'-spitter.png'},
                { icon = '__base__/graphics/icons/'..(parents[i] or 'small')..'-spitter.png', tint = tints[i] },
            },
            flags = { 'placeable-player', 'placeable-enemy', 'placeable-off-grid', 'breaths-air', 'not-repairable' },
            max_health = s.health or 10,
            order = 'b-b-d'..(i+10),
            subgroup = 'enemies',
            --factoriopedia_simulation = simulations.factoriopedia_small_spitter,
            impact_category = 'organic',
            resistances = {{ type = 'explosion', percent = 15, decrease = s.resistances.explosion }},
            healing_per_tick = s.healing_per_tick or 0.01,
            collision_box = s.collision_box or {{-0.3, -0.3}, {0.3, 0.3}},
            selection_box = s.selection_box or {{-0.4, -0.4}, {0.4, 0.4}},
            damaged_trigger_effect = hit_effects.biter(),
            sticker_box = {{-0.3, -0.5}, {0.3, 0.1}},
            distraction_cooldown = 300,
            min_pursue_time = 10 * 60,
            max_pursue_distance = 50,
            alternative_attacking_frame_sequence = spitter_alternative_attacking_animation_sequence,
            attack_parameters = spitter_attack_parameters({
                acid_stream_name = 'acid-stream-spitter-small',
                range = (s.attack_parameters.range or 0) + 13,
                min_attack_distance = 10,
                cooldown = s.attack_parameters.cooldown or 100,
                cooldown_deviation = s.attack_parameters.cooldown_deviation or 0.15,
                damage_modifier = s.attack_parameters.damage or 12,
                scale = scales[i],
                tint1 = tints[i],
                tint2 = tints[i],
                roarvolume = s.roarvolume or 0.4,
                range_mode = 'bounding-box-to-bounding-box',
            }),
            vision_distance = 30,
            movement_speed = s.movement_speed or 0.185,
            distance_per_frame = s.distance_per_frame or 0.04,
            absorptions_to_join_attack = { pollution = s.absorptions_to_join_attack or 4 },
            corpse = (parents[i] or 'small')..'-spitter-corpse',
            dying_explosion = (parents[i] or 'small')..'-spitter-die',
            working_sound = sounds.spitter_calls(0.1, 0.44),
            dying_sound = sounds.spitter_dying(0.45),
            run_animation = spitter_run_animation(scales[i], tints[i], tints[i]),
            running_sound_animation_positions = { 2 },
            walking_sound = sounds.spitter_walk(0, 0.3),
            ai_settings = { destroy_when_commands_fail = true, allow_try_return_to_spawner = true },
            water_reflection = spitter_water_reflection(scales[i]),
        }
    }
end

--- Spawn weights
--- Each entry has to start & finish with 0 weight (except at start/end of the range)
local weights = {
    { 'small',      {{0.00, 0.3}, {0.60, 0.0}}},              --    0% Small Biter / Small Spitter
    { 'medium',     {{0.20, 0.0}, {0.60, 0.3}, {0.90, 0.0}}}, --   20% Medium Biter / Medium Spitter
    { 'big',        {{0.50, 0.0}, {1.00, 0.4}, {1.50, 0.0}}}, --   50% Big Biter / Big Spitter
    { 'behemoth',   {{0.90, 0.0}, {1.00, 0.3}, {1.50, 0.0}}}, --   90% Behemoth Biter / Behemoth Spitter
    { 'overlord',   {{1.00, 0.0}, {1.50, 1.0}, {2.00, 0.0}}}, --  100% Overlord Biter / Overlord Spitter
    { 'adept',      {{1.50, 0.0}, {2.00, 1.0}, {2.50, 0.0}}}, --  150% Adept Biter / Adept Spitter
    { 'champion',   {{2.00, 0.0}, {2.50, 1.0}, {3.00, 0.0}}}, --  200% Champion Biter / Champion Spitter
    { 'warlord',    {{2.50, 0.0}, {3.00, 1.0}, {3.50, 0.0}}}, --  250% Warlord Biter / Warlord Spitter
    { 'conqueror',  {{3.00, 0.0}, {3.50, 1.0}, {4.00, 0.0}}}, --  300% Conqueror Biter / Conqueror Spitter
    { 'elder',      {{3.50, 0.0}, {4.00, 1.0}, {4.50, 0.0}}}, --  350% Elder Biter / Elder Spitter
    { 'arch',       {{4.00, 0.0}, {4.50, 1.0}, {5.00, 0.0}}}, --  400% Arch Biter / Arch Spitter
    { 'sovereign',  {{4.50, 0.0}, {5.00, 1.0}, {5.50, 0.0}}}, --  450% Sovereign Biter / Sovereign Spitter
    { 'tyrant',     {{5.00, 0.0}, {5.50, 1.0}, {6.00, 0.0}}}, --  500% Tyrant Biter / Tyrant Spitter
    { 'ascendant',  {{5.50, 0.0}, {6.00, 1.0}, {6.50, 0.0}}}, --  550% Ascendant Biter / Ascendant Spitter
    { 'primordial', {{6.00, 0.0}, {6.50, 1.0}, {7.00, 0.0}}}, --  600% Primordial Biter / Primordial Spitter
    { 'titan',      {{6.50, 0.0}, {7.00, 1.0}, {7.50, 0.0}}}, --  650% Titan Biter / Titan Spitter
    { 'colossus',   {{7.00, 0.0}, {7.50, 1.0}, {8.00, 0.0}}}, --  700% Colossus Biter / Colossus Spitter
    { 'mythic',     {{7.50, 0.0}, {8.00, 1.0}, {8.50, 0.0}}}, --  750% Mythic Biter / Mythic Spitter
    { 'legendary',  {{8.00, 0.0}, {8.50, 1.0}, {9.00, 0.0}}}, --  800% Legendary Biter / Legendary Spitter
    { 'epic',       {{8.50, 0.0}, {9.00, 1.0}, {9.50, 0.0}}}, --  850% Epic Biter / Epic Spitter
    { 'abyssal',    {{9.00, 0.0}, {9.50, 1.0}, {9.90, 0.0}}}, --  900% Abyssal Biter / Abyssal Spitter
    { 'eldritch',   {{9.50, 0.0}, {10.00, 0.4}}},             --  950% Eldritch Biter / Eldritch Spitter
    { 'leviathan',  {{9.90, 1.0}, {10.00, 0.6}}},             -- 1000% Leviathan Biter / Leviathan Spitter
}

for _, name in pairs{ 'biter', 'spitter' } do 
    local result_units = table.deepcopy(weights)

    for _, v in pairs(result_units) do
        v[1] = v[1]..'-'..name
        for _, w in pairs(v[2]) do
            w[1] = w[1] / 10
            w[2] = w[2] * 10
        end
    end

    data.raw['unit-spawner'][name..'-spawner'].result_units = result_units
end
