--- Map Settings
local ms = data.raw['map-settings']['map-settings']

ms.pollution.enabled = false
ms.enemy_evolution.time_factor = 0
ms.enemy_evolution.destroy_factor = 0
ms.enemy_evolution.pollution_factor = 0
ms.enemy_expansion.enabled = false

ms.path_finder.fwd2bwd_ratio = 2 -- default 5
ms.path_finder.goal_pressure_ratio = 3 -- default 2
ms.path_finder.general_entity_collision_penalty = 5 -- default 10
ms.path_finder.general_entity_subsequent_collision_penalty = 1 -- default 3
ms.path_finder.short_cache_size = 30 -- default 5
ms.path_finder.long_cache_size = 50 -- default 25
ms.path_finder.short_cache_min_cacheable_distance = 10 -- default 10
ms.path_finder.long_cache_min_cacheable_distance = 60 -- default 30
ms.path_finder.short_cache_min_algo_steps_to_cache = 50 -- default 50
ms.path_finder.max_clients_to_accept_any_new_request = 4 -- default 10
ms.path_finder.max_clients_to_accept_short_new_request = 150 -- default 100
ms.path_finder.start_to_goal_cost_multiplier_to_terminate_path_find = 10000 -- default 2000

--- Map Gen Settings
local mgs = data.raw.planet.nauvis.map_gen_settings

mgs.cliff_settings = { cliff_elevation_interval = 0, cliff_elevation_0 = 0 }
mgs.property_expression_names = { ['segmentation_multiplier'] = 0.1 }
mgs.starting_area = 2.5
mgs.autoplace_controls = {
    -- Resources
    ['coal']        = { frequency = 6.5,  size = 0.34,  richness = 0.24  },
    ['copper-ore']  = { frequency = 8.05, size = 0.352, richness = 0.35  },
    ['crude-oil']   = { frequency = 8,    size = 1.4,   richness = 0.45  },
    ['iron-ore']    = { frequency = 8.5,  size = 0.8,   richness = 0.23  },
    ['stone']       = { frequency = 6,    size = 0.385, richness = 0.25  },
    ['uranium-ore'] = { frequency = 2.2,  size = 1,     richness = 1     },
    -- Other
    ['enemy-base']  = { frequency = 1,    size = 1,     richness = 1     },
    ['trees']       = { frequency = 0.65, size = 0.04,  richness = 0.002 },
    ['water']       = { frequency = 10,   size = 0.3,   richness = 0.1   },
}
mgs.autoplace_settings = mgs.autoplace_settings or { tile = { settings = {} }}
mgs.autoplace_settings.tile.settings['moat'] = {}
mgs.autoplace_settings.tile.settings['refined-concrete'] = {}

--- Brightness
data.raw.planet.nauvis.surface_render_parameters = data.raw.planet.nauvis.surface_render_parameters or {}
data.raw.planet.nauvis.surface_render_parameters.day_night_cycle_color_lookup = {
    { 0.00, '__core__/graphics/color_luts/identity-lut.png' },
    { 0.15, '__core__/graphics/color_luts/identity-lut.png' },
    { 0.20, '__core__/graphics/color_luts/identity-lut.png' },
    { 0.45, '__core__/graphics/color_luts/lut-sunset.png'   },
    { 0.55, '__core__/graphics/color_luts/lut-sunset.png'   },
    { 0.80, '__core__/graphics/color_luts/identity-lut.png' },
    { 0.85, '__core__/graphics/color_luts/identity-lut.png' },
}
