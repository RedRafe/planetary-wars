local Config = require 'scripts.config'

local Tag = {}

local string_format = string.format
local table_keys = table.keys

---@alias TagData
---@field name string
---@field rank number
---@field default boolean

local tagged_players = {}
local tags = Config.tags

bb.subscribe({
    tags = tags,
    tagged_players = tagged_players,
}, function(tbl)
    tags = tags
    tagged_players = tbl.tagged_players
end)

-- == PLAYER ==================================================================

local function update_player_tag(player_index)
    local player = game.get_player(player_index)
    if not (player and player.valid) then
        return false
    end

    local _tag = tagged_players[player_index]
    if _tag then
        player.tag = string_format('[%s]', _tag)
    else
        player.tag = ''
    end
    return true
end

--- Returns the player's tag ID or ''
---@param player_index number
---@return string
Tag.get_player_tag = function(player_index)
    return tagged_players[player_index] or ''
end

--- Checks if tag exists and only applies if new tag is ranked equal/above old one
--- To enforce a new tag, use set_player_tag instead
---@param player_index number
---@param tag_name string
---@return boolean success|error
Tag.add_player_tag = function(player_index, tag_name)
    local new_tag = tags[tag_name]
    if not new_tag then
        return false
    end

    local old_name = Tag.get_player_tag(player_index)
    if old_name == tag_name then
        return false
    end

    local old_tag = tags[old_name]
    if old_tag and old_tag.rank > new_tag.rank then
        return false
    end

    tagged_players[player_index] = tag_name
    return update_player_tag(player_index)
end

--- Set player's tag
---@param player_index number
---@param tag_name string
---@return boolean success|error
Tag.set_player_tag = function(player_index, tag_name)
    local _tag = tags[tag_name]
    if not _tag then
        return false
    end

    tagged_players[player_index] = tag_name
    return update_player_tag(player_index)
end

--- Clear player's tag
---@param player_index number
---@return boolean success|error
Tag.clear_player_tag = function(player_index)
    tagged_players[player_index] = nil
    return update_player_tag(player_index)
end

--- Clear all players' tag
Tag.clear_all = function()
    for player_index in pairs(tagged_players) do
        Tag.clear_player_tag(player_index)
    end
end

-- == TAGS ====================================================================

---@param tag_name string
---@return TagData|nil
Tag.get_tag = function(tag_name)
    return tags[tag_name]
end

---@return string[]
Tag.get_tags = function()
    return table_keys(tags)
end

---@param tag_name string
---@param sprite string
---@return boolean success|error
Tag.add_tag = function(tag_name, sprite)
    local _tag = tags[tag_name]
    if _tag and _tag.default then
        return false
    end

    if not helpers.is_valid_sprite_path(sprite) then
        return false
    end

    tags[tag_name] = {
        rank = 3,
        sprite = sprite,
        default = false,
    }
    return true
end

--- Delete a non-default tag from the tag list
---@param tag_name string
---@return boolean success|error
Tag.delete_tag = function(tag_name)
    local _tag = tags[tag_name]
    if _tag and _tag.default then
        return false
    end

    tags[tag_name] = nil

    for player_index, old_tag_name in pairs(tagged_players) do
        if old_tag_name == tag_name then
            tagged_players[player_index] = nil
            update_player_tag(player_index)
        end
    end

    return true
end

--- Delete all non-default tags from the tag list
Tag.delete_tags = function()
    for tag_name, info in pairs(tags) do
        if not info.default then
            tags[tag_name] = nil
        end
    end

    for player_index in pairs(tagged_players) do
        update_player_tag(player_index)
    end
end

-- ============================================================================

return Tag
