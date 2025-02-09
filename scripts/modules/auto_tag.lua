local Tag = require 'scripts.public.tag'
local Game = require 'scripts.public.game'

local math_abs = math.abs
local for_players      = Game.for_players
local add_player_tag   = Tag.add_player_tag
local get_player_tag   = Tag.get_player_tag
local clear_player_tag = Tag.clear_player_tag

local OUTPOST_DISTANCE = 600
local EAST = 'East'
local WEST = 'West'

local function update_outpost_tag(player)
    local player_index = player.index
    local position = player.physical_position.x

    if math_abs(position) > OUTPOST_DISTANCE then
        add_player_tag(player_index, position > 0 and EAST or WEST)
    else
        local tag_name = get_player_tag(player_index)
        if tag_name == EAST or tag_name == WEST then
            clear_player_tag(player_index)
        end
    end
end

--- Once every ~minute
bb.add(3613, function()
    for_players(update_outpost_tag)
end, { on_nth_tick = true })
