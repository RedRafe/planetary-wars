local Chat = require 'scripts.public.chat'
local Enemy = require 'scripts.public.enemy'
local Force = require 'scripts.public.force'
local Game = require 'scripts.public.game'
local Permission = require 'scripts.public.permission'
local Rank = require 'scripts.public.rank'
local Teleport = require 'scripts.public.teleport'

bb.on_init(function()
    Force.on_init()
    Permission.on_init()
end)

bb.add(defines.events.on_console_chat, Chat.on_console_chat)
bb.add(defines.events.on_entity_died, Enemy.on_entity_died)
bb.add(defines.events.on_player_changed_force, Teleport.on_player_changed_force)
bb.add(defines.events.on_player_muted, Chat.on_player_muted)
bb.add(defines.events.on_player_unmuted, Chat.on_player_unmuted)

bb.on_trigger('on_enemy_entity_created', Enemy.on_enemy_entity_created)