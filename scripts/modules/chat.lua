local Chat = {}

local format = string.format
local force_names_map = {
    player = 'Spectator',
    north = 'North',
    south = 'South'
}

local muted_players = {}
bb.subscribe(muted_players, function(tbl) muted_players = tbl end)

Chat.is_muted = function(player_index)
    return muted_players[player_index] ~= nil
end

bb.add(defines.events.on_player_muted, function(event)
    muted_players[event.player_index] = true
end)

bb.add(defines.events.on_player_unmuted, function(event)
    muted_players[event.player_index] = nil
end)

--- Forward team chats to spectators
bb.add(defines.events.on_console_chat, function(event)
    local index = event.player_index
    local message = event.message
    if not (index and message) then
        return
    end

    if Chat.is_muted(index) then
        return
    end

    local player = game.get_player(index)
    if not (player and player.valid and player.character) then
        return
    end

    local player_force = player.force.name
    local player_tag = player.tag or ''
    local msg = format('%s %s (%s): %s', player.name, player_tag, force_names_map[player_force], message)

    if player_force == 'player' then
        if true then -- TODO: if not tournament mode
            game.forces.north.print(msg, { color = player.color })
            game.forces.south.print(msg, { color = player.color })
        end
    else
        if true then -- TODO: if not preparation phase
            game.forces.player.print(msg, { color = player.color })
        end
    end
end)

return Chat