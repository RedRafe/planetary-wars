local Config = require 'scripts.config'

local Force = {}

local function generate_force_table(side)
    return {
        threat = 0,
        name = string.capital_letter(side),
    }
end

local this = {
    north = generate_force_table('north'),
    south = generate_force_table('south'),
}

bb.subscribe(this, function(tbl) this = tbl end)

Force.north = function()
    return this.north
end

Force.south = function()
    return this.south
end

Force.on_init = function()
    local north = game.create_force('north')
    north.set_spawn_position(Config.spawn_point.north, 'nauvis')
    north.set_cease_fire('player', true)
    north.set_friend('player', true)
    north.share_chart = true

    local south = game.create_force('south')
    south.set_spawn_position(Config.spawn_point.south, 'nauvis')
    south.set_cease_fire('player', true)
    south.set_friend('player', true)
    south.share_chart = true
end

Force.on_map_reset = function()
    this.north = generate_force_table('north')
    this.south = generate_force_table('south')
    for _, f in pairs(game.forces) do
        f.reset()
    end
end

return Force