local Enemy = {}

local replace = string.replace
local math_round = math.round
local math_random = math.random

local tiers = require 'scripts.cache.enemy-tiers'
Enemy.tiers = tiers

--- Re-assigns unit-spawners and worms to the respective force when auto-placed
bb.on_trigger('on_enemy_entity_created', function(event)
    local entity = event.source_entity
    entity.force = (entity.position.y > 0) and 'north' or 'south'
end)

bb.add(defines.events.on_entity_died, function(event)
    local entity = event.entity
    if not (entity and entity.valid) then
        return
    end

    if entity.type ~= 'unit-spawner' then
        return
    end

    local unit = replace(entity.name, '-spawner')
    local evo = math_round(entity.force.get_evolution_factor() * 1000)
    local spawner_position = entity.position
    local force = entity.force
    local find_non_colliding_position = entity.surface.find_non_colliding_position
    local create_entity = entity.surface.create_entity
    local candidates = tiers[evo]

    for i = 1, math_random(8, 20) do
        local name = candidates[math_random(#candidates)] .. '-' .. unit
        local position = find_non_colliding_position(name, spawner_position, 8, 1)
        if position then
            create_entity {
                name = name,
                force = force,
                position = position,
            }
        end
    end
end)

bb.add(defines.events.on_match_finished, function()
    -- Freeze all moving parts
    for _, entity in pairs(game.surfaces.nauvis.find_entities_filtered({ type = { 'unit', 'unit-spawner', 'turret' } })) do
        entity.active = false
    end
end)

return Enemy
