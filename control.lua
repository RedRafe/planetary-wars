require '__planetary-wars__.utils.lib.lib'

bb.on_init(function()
    for _, side in pairs({ 'north', 'south' }) do
        if not game.forces[side] then
            game.create_force(side)
        end
    end
end)

--- Modules
require 'scripts.modules.auto_tag'
require 'scripts.modules.blueprints'
require 'scripts.modules.chat'
require 'scripts.modules.commands'
require 'scripts.modules.corpse_tag'
require 'scripts.modules.difficulty'
require 'scripts.modules.enemy'
require 'scripts.modules.feeding'
require 'scripts.modules.floaty_chat'
require 'scripts.modules.force'
require 'scripts.modules.freeplay'
require 'scripts.modules.game'
require 'scripts.modules.permission'
require 'scripts.modules.statistics'
require 'scripts.modules.teleport'
require 'scripts.modules.terrain'

--- GUIs
require 'scripts.gui.settings.main'
require 'scripts.gui.admin.main'
require 'scripts.gui.player.main'
require 'scripts.gui.browser.main'
