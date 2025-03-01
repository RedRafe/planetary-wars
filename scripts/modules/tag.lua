local Config = require 'scripts.config'

local Tag = {}

local table_keys = table.keys

Tag.DEFAULT_CREATOR = '<server>'

---@class TagData
---@field name string
---@field rank number
---@field sprite string
---@field localised_name string|LocalisedString
---@field created_by string

---@type TagData[]
local tags = {}

---@type table<number, string>
local tagged_players = {}

bb.subscribe({
    tags = tags,
    tagged_players = tagged_players,
}, function(tbl)
    tbl.tags = tags
    tagged_players = tbl.tagged_players
end)

-- == PLAYER MANAGER ==========================================================

---@param player_index number
---@return boolean success|error
local function update_player_tag(player_index)
    local player = player_index and game.get_player(player_index)
    if not (player and player.valid) then
        return false
    end

    local tag_name = tagged_players[player_index]
    local tag_data = tag_name and tags[tag_name]

    if tag_data then
        player.tag = {'', '[', tag_data.localised_name, ']'}
    else
        player.tag = ''
        tagged_players[player_index] = nil
    end

    return true
end

---@param player_index number
---@return boolean success|error
Tag.get_player_tag = function(player_index)
    return tagged_players[player_index]
end

---@param player_index number
---@param tag_name string
---@return boolean success|error
Tag.add_player_tag = function(player_index, tag_name)
    local tag_data = tags[tag_name]
    if not tag_data then
        return false
    end

    local old_name = Tag.get_player_tag(player_index)
    local old_data = old_name and tags[old_name]
    if (old_data == nil) or (old_data.rank > tag_data.rank) then
        return false
    end

    tagged_players[player_index] = tag_name
    return update_player_tag(player_index)
end

---@param player_index number
---@param tag_name string
---@return boolean success|error
Tag.set_player_tag = function(player_index, tag_name)
    if not tags[tag_name] then
        return false
    end

    tagged_players[player_index] = tag_name
    return update_player_tag(player_index)
end

---@param player_index number
---@return boolean success|error
Tag.remove_player_tag = function(player_index)
    tagged_players[player_index] = nil
    return update_player_tag(player_index)
end

---@return boolean success|error
Tag.remove_all_player_tags = function()
    local result = true

    for player_index in pairs(tagged_players) do
        result = result and Tag.remove_player_tag(player_index)
    end

    return result
end

---@return boolean success|error
Tag.remove_all_default_player_tags = function()
    local result = true

    for player_index, tag_name in pairs(tagged_players) do
        if Config.tag[tag_name] ~= nil then
            result = result and Tag.remove_player_tag(player_index)
        end
    end

    return result
end

---@param tag_name string
---@return number[]
Tag.get_players_by_tag = function(tag_name)
    local players = {}

    for player_index, current_tag in pairs(tagged_players) do
        if tag_name == current_tag then
            players[#players + 1] = player_index
        end
    end

    return players
end

-- == TAGS MANAGER ============================================================

---@param tag_name string
---@param args TagData
---@return TagData|nil
local function parse_tag_data(tag_name, args)
    -- check nil/empty tags
    if (tag_name == nil) or (tag_name == '') then
        return
    end

    -- check tags override
    if tags[tag_name] then
        return
    end

    -- check valid icon
    if not args.sprite or not helpers.is_valid_sprite_path(args.sprite) then
        return
    end

    local result = {
        name = tag_name,
        rank = args.rank or Config.tag_rank.custom,
        sprite = args.sprite,
        localised_name = args.localised_name or tag_name,
        created_by = args.created_by or Tag.DEFAULT_CREATOR
    }

    if Config.tag[tag_name] then
        result.localised_name = { 'tag.'..tag_name }
    end

    return result
end

---@param tag_name string
---@return TagData|nil
Tag.get_tag = function(tag_name)
    return tags[tag_name]
end

---@return TagData[]
Tag.get_tags = function()
    return tags
end

---@return string[]
Tag.get_tags_list = function()
    return table_keys(tags)
end

---@param tag_name string
---@param args TagData
---@return boolean success|error
Tag.add_tag = function(tag_name, args)
    local tag_data = parse_tag_data(tag_name, args)
    if not tag_data then
        return false
    end

    tags[tag_name] = tag_data
    return true
end

---@param tag_name string
---@return boolean success|error
Tag.remove_tag = function(tag_name)
    tags[tag_name] = nil

    local result = false

    for player_index, player_tag in pairs(tagged_players) do
        if player_tag == tag_name then
            result = result or update_player_tag(player_index)
        end
    end

    return result
end

---@return boolean success|error
Tag.remove_all_tags = function()
    local result = true

    for tag_name in pairs(tags) do
        result = result and Tag.remove_tag(tag_name)
    end

    return result
end

-- == EVENTS ==================================================================

bb.on_init(function()
    for tag_name, tag_data in pairs(Config.tag) do
        Tag.add_tag(tag_name, tag_data)
    end
end)

bb.add(defines.events.on_map_reset, function()
    Tag.remove_all_default_player_tags()
end)

bb.add(defines.events.on_player_removed, function(event)
    Tag.remove_player_tag(event.player_index)
end)

-- ============================================================================

return Tag