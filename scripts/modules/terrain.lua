local Public = {}

local function set_landing_pad_tiles(entity)
    local pos = entity.position
    local surface = entity.surface
    surface.request_to_generate_chunks(pos, 1)
    surface.force_generate_chunk_requests()

    local tiles = {}
    for x = -11.5, 11.5 do
        for y = -11.5, 11.5 do
            tiles[#tiles + 1] = { name = 'refined-hazard-concrete-left', position = { pos.x + x, pos.y + y } }
        end
    end
    for x = -7.5, 7.5 do
        for y = -7.5, 7.5 do
            tiles[#tiles + 1] = { name = 'concrete', position = { pos.x + x, pos.y + y } }
        end
    end
    surface.set_tiles(tiles, true)
end

local function clear_landing_pad_area(args)
    local surface = game.surfaces.nauvis
    local filter = {
        position = args.position,
        radius = args.radius,
        collision_mask = { 'player', 'object' },
    }
    for _, entity in pairs(surface.find_entities_filtered(filter)) do
        entity.destroy()
    end

    filter.collision_mask = nil

    local tiles = {}
    for _, tile in pairs(surface.find_tiles_filtered(filter)) do
        tiles[#tiles + 1] = { name = 'refined-concrete', position = tile.position }
    end
    surface.set_tiles(tiles, false)
end

bb.add(defines.events.on_map_init, function()
    local surface = game.surfaces.nauvis
    local start = { x = -32 + math.random(0, 64), y = -102 }
    local radius = 9

    for _, ref in pairs({
        { force = 'north', position = start },
        { force = 'south', position = { x = start.x, y = -start.y } }
    }) do
        clear_landing_pad_area{ position = ref.position, radius = radius }

        local position = surface.find_non_colliding_position('cargo-landing-pad', ref.position, radius, 1, true)
        assert(position, 'No position found for cargo landing pad')

        local entity = surface.create_entity {
            name = 'cargo-landing-pad',
            position = position,
            force = ref.force,
        }
        assert(entity, 'Invalid cargo landing pad')

        entity.minable_flag = false
        set_landing_pad_tiles(entity)
    end

    game.forces.player.chart_all()
end)

bb.add(defines.events.on_map_reset, function()
    local surface = game.surfaces.nauvis
    local mgs = surface.map_gen_settings
    mgs.seed = math.random(341, 4294967294)
    surface.map_gen_settings = mgs

    surface.clear(true)
    surface.request_to_generate_chunks({ x = 0, y = 0 }, 8)
    surface.force_generate_chunk_requests()
end)

return Public
