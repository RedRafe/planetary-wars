local Colors = require 'utils.colors'
local Shared = require 'utils.shared'
local Utils = require 'scripts.modules.utils'
local tiers = require 'scripts.cache.enemy-tiers'

local Enemy = {}

local math_round = math.round
local math_random = math.random

local triggers = Shared.triggers
local create_local_flying_text = Utils.create_local_flying_text
local turret_search_filter = { radius = 70, type = 'unit-spawner', limit = 1 }
local turret_warning_message = { text = { 'warning.prevent_turret_creep' }, color = Colors.red }

--- Re-assigns unit-spawners and worms to the respective force when auto-placed
bb.on_trigger(triggers.on_enemy_created, function(event)
    local entity = event.source_entity
    if not (entity and entity.valid) then
        return
    end

    entity.force = (entity.position.y > 0) and 'north' or 'south'
end)

--- Prevent turret creep
bb.on_trigger(triggers.on_built_turret, function(event)
    local entity = event.source_entity
    if not (entity and entity.valid) then
        return
    end

    turret_search_filter.position = entity.position
    turret_search_filter.force = (entity.force.name == 'north') and 'south' or 'north'
    if entity.surface.count_entities_filtered(turret_search_filter) == 0 then
        return
    end

    if entity.name ~= 'entity-ghost' then
        -- refund item to robot/player
        local stack = entity.prototype.items_to_place_this[1]
        if stack then
            stack.quality = entity.quality
            local actor = event.robot or (event.player_index and game.get_player(event.player_index))
            if actor and actor.valid and actor.can_insert(stack) then
                actor.insert(stack)
            end
        end
    end

    turret_warning_message.position = entity.position
    create_local_flying_text(turret_warning_message, entity.force)
    entity.destroy({ raise_destroy = false })
end)

--- Spawn biters when spawners are killed
bb.add(defines.events.on_entity_died, function(event)
    local entity = event.entity
    if not (entity and entity.valid) then
        return
    end

    if entity.type ~= 'unit-spawner' then
        return
    end

    local unit = entity.name:sub(1, -9) -- remove '-spawner'
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

--- Freeze all moving parts at the end of the match
bb.add(defines.events.on_match_finished, function()
    for _, entity in pairs(game.surfaces.nauvis.find_entities_filtered({ type = { 'unit', 'unit-spawner', 'turret' } })) do
        entity.active = false
    end
end)

return Enemy
