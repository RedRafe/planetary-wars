local Config = require 'scripts.config'
local Shared = require 'utils.shared'

local Force = {}

local function generate_force_table(side)
    return {
        threat = -1e9,
        name = string.capital_letter(side),
        cargo_landing_pad = false,
        critical_entities = {},
    }
end

local forces = {
    north = generate_force_table('north'),
    south = generate_force_table('south'),
}
local critical_entities_map = {}

bb.subscribe({
    forces = forces,
    critical_entities_map = critical_entities_map
}, function(tbl)
    forces = tbl.forces
    critical_entities_map = critical_entities_map
end)

Force.north = function()
    return forces.north
end

Force.south = function()
    return forces.south
end

---@param entity LuaEntity
---@return boolean success|error
Force.register_critical_entity = function(entity)
    if not (entity and entity.valid and entity.unit_number) then
        return false
    end

    local force = forces[entity.force.name]
    if not force then
        return false
    end

    force.critical_entities[entity.unit_number] = true
    critical_entities_map[entity.unit_number] = entity.force.name
    bb.register_on_object_destroyed(entity)
    return true
end

bb.on_init(function()
    local north = game.forces.north
    north.set_spawn_position(Config.spawn_point.north, 'nauvis')
    north.set_cease_fire('player', true)
    north.set_friend('player', true)
    north.share_chart = true

    local south = game.forces.south
    south.set_spawn_position(Config.spawn_point.south, 'nauvis')
    south.set_cease_fire('player', true)
    south.set_friend('player', true)
    south.share_chart = true
end)

bb.add(defines.events.on_map_init, function()
    forces.north = generate_force_table('north')
    forces.south = generate_force_table('south')
end)

bb.add(defines.events.on_map_reset, function()
    for _, f in pairs(game.forces) do
        f.reset()
    end

    for _, player in pairs(game.players) do
        player.force = 'player'
    end
end)

bb.on_trigger(Shared.triggers.on_cargo_landing_pad_created, function(event)
    local entity = event.source_entity
    if not Force.register_critical_entity(entity) then
        return
    end

    -- if not, initialize 1st cargo landing pad of the force
    if not forces[entity.force.name].cargo_landing_pad then
        forces[entity.force.name].cargo_landing_pad = entity
    end
end)

bb.add(defines.events.on_object_destroyed, function(event)
    local unit_number = event.useful_id
    if not unit_number then
        return
    end

    local side = critical_entities_map[unit_number]
    if not side then
        return
    end

    critical_entities_map[unit_number] = nil
    forces[side].critical_entities[unit_number] = nil

    local critical_entities_count = table.size(forces[side].critical_entities)
    if critical_entities_count == 0 then
        bb.raise_event(defines.events.on_critical_entity_destroyed, {
            name = defines.events.on_critical_entity_destroyed,
            tick = event.tick,
            unit_number = unit_number,
            force = game.forces[side],
            critical_entities_count = critical_entities_count,
        })
    end
end)

return Force
