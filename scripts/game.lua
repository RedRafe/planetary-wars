local Game = {}

bb.on_init(function()
    game.create_force('north')
    game.create_force('south')
end)

return Game