local Force = require 'scripts.modules.force'
local Game = require 'scripts.modules.game'
local Permission = require 'scripts.modules.permission'

bb.on_init(function()
    Force.on_init()
    Permission.on_init()
    Game.on_init()
end)
