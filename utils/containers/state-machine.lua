-- luacheck: globals script
-- luacheck: globals game
local Task = require 'scripts.core.task'
local Token = require 'scripts.core.token'

local StateMachine = {}
StateMachine.__index = StateMachine

script.register_metatable('StateMachine', StateMachine)

---@param states table<string, number>
---@param events table<number, number>
function StateMachine.new(states, events)
    local _, startup = next(states)

    local obj = setmetatable({
        states = states,
        events = events,
        current_state = startup,
    }, StateMachine)

    return obj
end

---@param state number
---@param data? table
function StateMachine:raise_event_for_state(state, data)
    local event = self.events[state]

    if event then
        return script.raise_event(event, data or {})
    end

    error('Unknown state: ' .. serpent.line(state))
end

---@param state number
---@param data? table
function StateMachine:set_state(state, data)
    self.current_state = state
    self:raise_event_for_state(state, data)
end

local set_state_callback = Token.register(function(tbl)
    StateMachine.set_state(tbl.self, tbl.state, tbl.data)
end)

---@param next_state number
---@param data? table
function StateMachine:transition(next_state, data)
    next_state = next_state or (self.current_state + 1) % table.size(self.states)

    local _, startup = next(self.states)
    if next_state == startup and game.tick > 0 then
        next_state = next_state + 1
    end

    Task.set_timeout_in_ticks(1, set_state_callback, {
        self = self,
        state = next_state,
        data = data,
    })
end

---@return number
function StateMachine:get_state()
    return self.current_state
end

return StateMachine
