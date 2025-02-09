local Game = {}

Game.north = function()
    return game.forces.north
end

Game.south = function()
    return game.forces.south
end

Game.player = function()
    return game.forces.player
end

Game.surface = function()
    return game.surfaces.nauvis
end

Game.for_teams = function(callback, ...)
    local forces = game.forces

    callback(forces.north, ...)
    callback(forces.south, ...)
end

Game.for_forces = function(callback, ...)
    local forces = game.forces

    callback(forces.north, ...)
    callback(forces.south, ...)
    callback(forces.player, ...)
end

Game.for_players = function(callback, ...)
    local forces = game.forces

    for _, player in pairs(forces.north) do
        callback(player, ...)
    end
    for _, player in pairs(forces.south) do
        callback(player, ...)
    end
end

return Game
