local Game = require 'scripts.modules.game'

local Actions = {}

Actions.instant_map_reset = function()
    bb.raise_event(defines.events.on_map_reset, {})
end

Actions.transition = function()
    Game.transition()
end

return Actions