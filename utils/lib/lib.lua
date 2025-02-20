-- luacheck: ignore data
-- luacheck: ignore script

_G.bb = {}
_DEBUG = true

local function require_lib(path)
    for k, v in pairs(require(path)) do
        if bb[k] ~= nil then
            error(string.format('Trying to override lib function %s from %s', k, path))
        end
        bb[k] = v
    end
end

bb.print = function(any)
    if not _DEBUG then
        return
    end

    local obj
    if type(any) == 'string' or type(any) == 'number' or type(any) == 'boolean' then
        obj = any
    else
        obj = serpent.block(any)
    end

    if game then
        game.print(obj)
    else
        log(obj)
    end
end

-- BB LIBRARY
--=============================================================================

require 'utils.lib.math'
require 'utils.lib.string'
require 'utils.lib.table'

if data and data.raw and not data.raw.item then
    bb.stage = 'settings'
elseif data and data.raw then
    bb.stage = 'data'
    require_lib 'utils.lib.data'
elseif script then
    bb.stage = 'control'
    require_lib 'utils.lib.control'
else
    error('Could not determine load order stage.')
end
