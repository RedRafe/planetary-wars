local Force = {}

Force.on_init = function()
    local north = game.create_force('north')
    north.set_spawn_position({ 0, -90}, 'nauvis')
    north.set_cease_fire('player', true)
    north.set_friend('player', true)
    north.share_chart = true

    local south = game.create_force('south')
    south.set_spawn_position({ 0, 90}, 'nauvis')
    south.set_cease_fire('player', true)
    south.set_friend('player', true)
    south.share_chart = true
end

return Force