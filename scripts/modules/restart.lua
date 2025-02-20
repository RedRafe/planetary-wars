bb.add(defines.events.on_map_reset, function()
    for _, player in pairs(game.players) do
        if player.ticks_to_respawn then
            player.ticks_to_respawn = nil
        end
        if player.force ~= 'player' then
            player.force = 'player'
        end
    end

    local surface = game.surfaces.nauvis
    local mgs = surface.map_gen_settings
    mgs.seed = math.random(341, 4294967294)
    surface.map_gen_settings = mgs

    surface.clear(true)
    surface.request_to_generate_chunks({ x = 0, y = 0 }, 8)
    surface.force_generate_chunk_requests()
end)