local Buckets = require 'utils.containers.buckets'
local Tag = require 'scripts.modules.tag'

local math_abs = math.abs
local add_player_tag   = Tag.add_player_tag
local get_player_tag   = Tag.get_player_tag
local remove_player_tag = Tag.remove_player_tag

local NTH_TICK = 36
local OUTPOST_DISTANCE = 600
local EAST = 'east'
local WEST = 'west'

local online_players = Buckets.new(math.ceil(60 * 60 / NTH_TICK))
bb.subscribe(online_players, function(tbl) online_players = tbl end)

---@param player_index number
---@param player? LuaPlayer
local function update_player_tag(player_index, player)
    if not player then
        player = game.get_player(player_index)
    end
    local position = player.physical_position.x

    if math_abs(position) > OUTPOST_DISTANCE then
        add_player_tag(player_index, position > 0 and EAST or WEST)
    else
        local tag_name = get_player_tag(player_index)
        if tag_name == EAST or tag_name == WEST then
            remove_player_tag(player_index)
        end
    end
end

bb.add(defines.events.on_player_joined_game, function(event)
    online_players:add(event.player_index, game.get_player(event.player_index))
end)

bb.add(defines.events.on_player_left_game, function(event)
    online_players:remove(event.player_index)
end)

bb.add(NTH_TICK, function(event)
    for player_index, player in pairs(online_players:get_bucket(event.tick)) do
        if player.valid then
            update_player_tag(player_index, player)
        else
            online_players:remove(player_index)
        end
    end
end, { on_nth_tick = true })

bb.add(defines.events.on_player_removed, function(event)
    online_players:remove(event.player_index)
end)
