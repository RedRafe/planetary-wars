local Config = require 'scripts.config'
local StateMachine = require 'utils.containers.state-machine'

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

local this = {
    tick_started = -1,
    tick_finished = -1,
}

bb.subscribe({ this = this, game_state = game_state }, function(tbl)
    this = tbl.this
    game_state = tbl.game_state
end)

---@return GameState
Game.state = function()
    return game_state:get_state()
end

---@param state? GameState
Game.transition = function(state)
    game_state:transition(state)
end

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

Game.on_init = function()
    Game.transition()
end

bb.add(defines.events.on_map_reset, function()
    this.tick_started = -1
    this.tick_finished = -1
    game.reset_game_state()
    game.reset_time_played()
end)

bb.add(defines.events.on_match_started, function()
    this.tick_started = game.tick
end)

bb.add(defines.events.on_match_finished, function()
    this.tick_finished = game.tick
end)

return Game
