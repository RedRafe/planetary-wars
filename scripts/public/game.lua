local StateMachine = require 'utils.containers.state-machine'

local Game = {}

---@alias GameState
local states = {
    initializing = 0,
    picking      = 1,
    preparing    = 2,
    playing      = 3,
    finished     = 4,
    resetting    = 5,
}

local events = {
    [states.picking]   = defines.events.on_match_picking_phase,
    [states.preparing] = defines.events.on_match_preparation_phase,
    [states.playing]   = defines.events.on_match_started,
    [states.finished]  = defines.events.on_match_finished,
    [states.resetting] = defines.events.on_map_reset,
}

local this = {
    state = StateMachine.new(states, events),
    tick_started = -1,
    tick_finished = -1,
}

bb.subscribe(this, function(tbl)
    this = tbl
end)

---@return GameState
Game.state = function()
    return this.state:get_state()
end

---@param state? GameState
Game.transition = function(state)
    this.state:transition(state)
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

Game.on_map_reset = function()
    this.tick_started = -1
    this.tick_finished = -1
    game.reset_game_state()
    game.reset_time_played()
end

Game.on_match_started = function()
    this.tick_started = game.tick
end

Game.on_match_finished = function()
    this.tick_finished = game.tick
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
