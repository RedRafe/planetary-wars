local Public = {}

-- CONTROL UTIL LIBRARY
--=============================================================================

-- Event
local Event = require 'utils.event'
Public.add = Event.add
Public.remove = Event.remove
Public.on_init = Event.on_init
Public.on_load = Event.on_load
Public.on_configuration_changed = Event.on_configuration_changed
Public.on_built = Event.on_built
Public.on_destroyed = Event.on_destroyed
Public.on_built_tile = Event.on_built_tile
Public.on_mined_tile = Event.on_mined_tile
Public.on_trigger = Event.on_trigger
Public.raise_event = Event.raise_event
Public.register_on_object_destroyed = Event.register_on_object_destroyed

-- Storage
local Storage = require 'utils.storage'
Public.subscribe = Storage.subscribe
Public.subscribe_init = Storage.subscribe_init

-- Task
local Task = require 'utils.task'
Public.queue_task = Task.queue_task
Public.set_timeout = Task.set_timeout
Public.set_timeout_in_ticks = Task.set_timeout_in_ticks

-- Token
local Token = require 'utils.token'
Public.register = Token.register

return Public
