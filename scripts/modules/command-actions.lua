local Game = require 'scripts.modules.game'

local Actions = {}

Actions.instant_map_reset = function()
    bb.raise_event(defines.events.on_map_reset, {})
end

Actions.transition = function()
    Game.transition()
end

Actions.hax = function()
    for _, recipe in pairs(game.player.force.recipes) do
        recipe.enabled = true
    end
end

return Actions