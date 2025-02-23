bb.on_built(function(event)
    local entity = event.entity
    if not (entity and entity.valid) then
        return
    end

    if entity.type ~= 'entity-ghost' and entity.type ~= 'tile-ghost' then
        return
    end

    local force = entity.force.name == 'north'
    local side = entity.position.y < 0
    if force == side then
        return
    end

    entity.destroy()
end)

bb.add(defines.events.on_marked_for_deconstruction, function(event)
    local entity = event.entity
    if not (entity and entity.valid) then
        return
    end

    local force_name = entity.force.name
    local force = force_name == 'north'
    local side = entity.position.y < 0
    if force == side then
        return
    end

    entity.cancel_deconstruction(force_name)
end)