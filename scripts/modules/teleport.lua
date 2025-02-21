local Config = require 'scripts.config'

local Teleport = {}

--- Safely teleports a player to its destination
---@param player LuaPlayer
---@param destination? MapPosition, defaults to spawn
Teleport.teleport = function(player, destination)
    if not (player and player.valid) then
        return
    end

    local surface = game.surfaces.nauvis
    local position = surface.find_non_colliding_position('character', destination or Config.spawn_point.player, 10, 0.4, false)
    if position then
        player.teleport(position, surface, true)
    end
end

---@param player_list? LuaPlayer[], array of players. Defaults to game.players
---@param destination? MapPosition, defaults to spawn
Teleport.teleport_all = function(player_list, destination)
    for _, player in pairs(player_list or game.players) do
        Teleport.teleport(player, destination)
    end
end

bb.add(defines.events.on_player_changed_force, function(event)
    local player = event.player_index and game.get_player(event.player_index)
    local destination = Config.spawn_point[player and player.force.name]
    Teleport.teleport(player, destination)
end)

return Teleport