local Config = require 'scripts.config'
local Special = require 'scripts.modules.special'
local StateMachine = require 'utils.containers.state-machine'

local key_of = table.index_of

local Game = {}

local events = {
    [Config.game_state.initializing] = defines.events.on_map_init,
    [Config.game_state.picking]      = defines.events.on_match_picking_phase,
    [Config.game_state.preparing]    = defines.events.on_match_preparation_phase,
    [Config.game_state.playing]      = defines.events.on_match_started,
    [Config.game_state.finished]     = defines.events.on_match_finished,
    [Config.game_state.resetting]    = defines.events.on_map_reset,
}

local game_state = StateMachine.new(Config.game_state, events)

local this = {}

local function generate_game_table()
    this.tick_started  = -1
    this.tick_finished = -1
    this.winning_force = false
    this.losing_force  = false
end

local function assert_game_sequence(expected_state, event)
    if not (event and event.override) then
        local current_state = Game.state()
        assert(
            current_state == expected_state,
            string.format('Invalid game state: "%s" expected, got "%s"', key_of(Config.game_state, expected_state), key_of(Config.game_state, current_state))
        )
    end
end

bb.subscribe({ this = this, game_state = game_state }, function(tbl)
    this = tbl.this
    game_state = tbl.game_state
end)

-- == GAME LIB ================================================================

---@return GameState
Game.state = function()
    return game_state:get_state()
end

---@param state? GameState
---@param data? table
Game.transition = function(state, data)
    game_state:transition(state, data)
end

Game.next_state_token = bb.register(function(tbl)
    Game.transition(tbl.state, tbl.data)
end)

---@return number
Game.ticks = function()
    if this.tick_started < 0 then
        -- Not started
        return 0
    elseif this.tick_finished < 0 then
        -- Ongoing
        return game.tick - this.tick_started
    else
        -- Finished
        return this.tick_finished - this.tick_started
    end
end

-- == EVENTS ==================================================================

bb.on_init(function()
    Game.transition()
end)

bb.add(defines.events.on_map_init, function(event)
    assert_game_sequence(Config.game_state.initializing, event)

    generate_game_table()

    bb.set_timeout(1, Game.next_state_token, {})
end)

bb.add(defines.events.on_match_picking_phase, function(event)
    assert_game_sequence(Config.game_state.picking, event)

    if Special.enabled() then
        return
    end

    bb.set_timeout(1, Game.next_state_token, {})
end)

bb.add(defines.events.on_match_preparation_phase, function(event)
    assert_game_sequence(Config.game_state.preparing, event)

    if Special.enabled() then
        return
    end

    bb.set_timeout(1, Game.next_state_token, {})
end)

bb.add(defines.events.on_match_started, function(event)
    assert_game_sequence(Config.game_state.playing, event)

    this.tick_started = game.tick
end)

bb.add(defines.events.on_match_finished, function(event)
    assert_game_sequence(Config.game_state.finished, event)

    this.tick_finished = game.tick
    this.winning_force = event.winning_force
    this.losing_force = event.losing_force

    -- Call map reset after 90s
    bb.set_timeout(10, Game.next_state_token, {})
end)

bb.add(defines.events.on_map_reset, function(event)
    assert_game_sequence(Config.game_state.resetting, event)

    game.reset_game_state()
    game.reset_time_played()

    bb.set_timeout(1, Game.next_state_token, {})
end)

bb.add(defines.events.on_critical_entity_destroyed, function(event)
    -- Ignore destroy events on cleanup
    if Game.state() == Config.game_state.resetting then
        return
    end

    assert_game_sequence(Config.game_state.playing, event)

    if event.critical_entities_count ~= 0 then
        return
    end

    Game.transition(Config.game_state.finished, {
        winning_force = (event.force.name == 'north') and 'south' or 'north',
        losing_force = (event.force.name == 'north') and 'north' or 'south',
    })
end)

-- ============================================================================

return Game
