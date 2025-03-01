local Config = require 'scripts.config'
local Difficulty = require 'scripts.modules.difficulty'
local Force = require 'scripts.modules.force'
local Game = require 'scripts.modules.game'
local Utils = require 'scripts.modules.utils'

local Feeding = {}

local get_force = Utils.get_force

---@type table<string, number>
local items = {}
local auto_feed = {}

bb.subscribe({
    items = items,
    auto_feed = auto_feed,
}, function(tbl)
    items = tbl.items
    auto_feed = tbl.auto_feed
end)

-- == ITEM MANAGER ============================================================

---@param name string
Feeding.get_item = function(name)
    return items[name]
end

---@param name string
---@param value number|nil, use nil to remove the item
Feeding.set_item = function(name, value)
    assert(name)
    items[name] = value
end

Feeding.get_all_items = function()
    return items
end

Feeding.remove_all_items = function()
    for i in pairs(items) do
        items[i] = nil
    end
end

---@param name string
Feeding.get_default_item = function(name)
    return Config.item_value[name]
end

---@param name string
Feeding.set_default_item = function(name)
    if Config.item_value[name] then
        items[name] = Config.item_value[name]
    end
end

Feeding.reset_all_default_items = function()
    for i in pairs(items) do
        items[i] = nil
    end
    for k, v in pairs(Config.item_value) do
        items[k] = v
    end
end

bb.add(defines.events.on_map_init, function()
    Feeding.reset_all_default_items()
end)

-- == EVO MANAGER =============================================================

---@param force ForceID, string|LuaForce
Feeding.get_evolution = function(force)
    return get_force(force).get_evolution_factor()
end

---@param force ForceID, string|LuaForce
---@param value number
Feeding.set_evolution = function(force, value)
    get_force(force).set_evolution_factor(value)
end

---@param force ForceID, string|LuaForce
---@param value number
Feeding.add_evolution = function(force, value)
    force = get_force(force)
    force.set_evolution_factor(force.get_evolution_factor() + value)
end

-- == THREAT MANAGER ==========================================================

---@param force ForceID, string|LuaForce
Feeding.get_threat = function(force)
    return Force.get(force).threat
end

---@param force ForceID, string|LuaForce
---@param value number
Feeding.set_threat = function(force, value)
    Force.get(force).threat = value
end

---@param force ForceID, string|LuaForce
---@param value number
Feeding.add_threat = function(force, value)
    local force_data = Force.get(force)
    force_data.threat = force_data.threat + value
end

-- == FEED MANAGER ============================================================

Feeding.get_auto_feed = function()
    return auto_feed
end

---@param new_auto_feed table<string, number>
Feeding.set_auto_feed = function(new_auto_feed)
    for i in pairs(auto_feed) do
        auto_feed[i] = nil
    end
    for k, v in pairs(new_auto_feed) do
        auto_feed[k] = v
    end
end

--TODO: add scale factor based on # of players
---@param args
---@field contents ItemWithQualityCounts[]
---@field target LuaForce|string
Feeding.compute = function(args)
    local target = args.target
    local starting_evo = Feeding.get_evolution(target)
    local starting_threat = Feeding.get_threat(target)

    local feed_total = 0

    for _, item_stack in pairs(args.contents) do
        local item = items[item_stack.name]
        if item then
            feed_total = feed_total + item.value * item_stack.count
        end
    end

    feed_total = feed_total * Difficulty.get().value

    local e2 = (starting_evo * 100) + 1
    local evo_modifier = (1 / (10 ^ (e2 * 0.015))) / (e2 * 0.5)
    local threat_modifier = 1 / (0.2 + (e2 * 0.16))

    local diff_evo = evo_modifier * feed_total
    local diff_threat = threat_modifier * feed_total

    local final_evo = starting_evo + diff_evo
    local final_threat = starting_threat + diff_threat

    return {
        evo = {
            start = starting_evo,
            diff = diff_evo,
            final = final_evo,
        },
        threat = {
            start = starting_threat,
            diff = diff_threat,
            final = final_threat
        }
    }
end

---@param args
---@field contents ItemWithQualityCounts[]
---@field target LuaForce|string
Feeding.feed = function(args)
    local target = args.target
    local results = Feeding.compute(args)

    Feeding.set_evolution(target, results.evo.final)
    Feeding.set_threat(target, results.threat.final)
end

bb.add(60, function()
    if not Game.is_playing() then
        return
    end

    Feeding.feed({ target = 'north', contents = auto_feed })
    Feeding.feed({ target = 'south', contents = auto_feed })
end, { on_nth_tick = true })

bb.add(defines.events.on_map_init, function()
    Feeding.set_auto_feed(Config.auto_feed)
end)

bb.add(defines.events.on_player_fed, function(event)
    local player = game.get_player(event.player_index)
    if not (player and player.valid) then
        return
    end

    local inv = player.get_main_inventory()
    if not (inv and inv.valid and not inv.is_empty()) then
        return
    end

    Feeding.feed({
        contents = inv.get_contents(),
        target = event.target or (player.force.name == 'north') and 'south' or 'north'
    })
end)

-- ============================================================================

return Feeding
