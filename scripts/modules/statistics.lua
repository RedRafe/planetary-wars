local Config = require 'scripts.config'
local Game = require 'scripts.modules.game'
local Queue = require 'utils.containers.queue'
local ItemStatistics = require 'scripts.modules.item-statistics'
local tracked_items = Config.production

local Statistics = {}

local MAX_STORED_GAMES = 10

local past = Queue.new()
local current = {}
local stats = {
    north = {},
    south = {},
}

bb.subscribe({
    past = past,
    current = current,
    stats = stats,
}, function(tbl)
    past = tbl.past
    current = tbl.current
    stats = tbl.stats
end)

Statistics.get_current = function()
    return current
end

---@param index? number
Statistics.get_past = function(index)
    if index then
        return past:peek(index)
    else
        return past:to_array()
    end
end

bb.add(defines.events.on_tick, function()
    if not Game.is_playing() then
        return
    end

    local item_index = (game.tick % #tracked_items) + 1
    local item_name = tracked_items[item_index]

    for _, side in pairs({ 'north', 'south' }) do
        local force_stats = stats[side]
        local item_stats = current[side][item_name]

        item_stats.produced = item_stats.produced + force_stats.get_input_count(item_name)
        item_stats.consumed = item_stats.consumed + force_stats.get_input_count(item_name)
        item_stats:get_stored()
    end
end)

bb.add(defines.events.on_map_init, function()
    for _, side in pairs({ 'north', 'south' }) do
        -- Cache LuaFlowStatistics
        stats[side] = game.forces[side].get_item_production_statistics('nauvis')

        -- Init ItemStatistics[]
        local force_stats = {}

        for _, item_name in pairs(tracked_items) do
            force_stats[item_name] = ItemStatistics.new({ name = item_name })
        end

        current[side] = force_stats
    end
end)

bb.add(defines.events.on_match_finished, function(event)
    current.ticks = Game.ticks()
    current.winning_force = event.winning_force
    current.losing_force = event.losing_force
end)

bb.add(defines.events.on_map_reset, function()
    -- Push only 'real' games
    if current.ticks and current.ticks > 0 then
        past:push(table.deepcopy(current))
    end

    -- Pop oldest record
    while past:size() > MAX_STORED_GAMES do
        past:pop()
    end

    -- Reset current table
    for k, _ in pairs(current) do
        current[k] = nil
    end
end)

return Statistics
