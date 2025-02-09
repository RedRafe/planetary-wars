local Permission = {}

Permission.groups = {
    default = 'Default',
    player = 'Player',
    spectator = 'Player',
    jail = 'Jail'
}

---@param group_name string, name of the group. If not existing, it will be created a new one
---@param allowed boolean
---@param action_list InputAction[], defaults to all input actions
Permission.apply_permissions = function(group_name, allowed, action_list)
    local group = game.permissions.get_group(group_name)

    if not group then
        group = game.permissions.create_group(group_name)
    end

    for _, action_id in pairs(action_list or defines.input_action) do
        group.set_allows_action(action_id, allowed)
    end
end

Permission.on_init = function()
    Permission.apply_permissions('Default', false, {
        defines.input_action.import_blueprint_string,
        defines.input_action.open_blueprint_library_gui,
    })

    Permission.apply_permissions('Player', false)
    Permission.apply_permissions('Player', true, {
        defines.input_action.admin_action,
        defines.input_action.change_active_item_group_for_filters,
        defines.input_action.change_active_quick_bar,
        defines.input_action.change_multiplayer_config,
        defines.input_action.clear_cursor,
        defines.input_action.edit_permission_group,
        defines.input_action.gui_checked_state_changed,
        defines.input_action.gui_click,
        defines.input_action.gui_confirmed,
        defines.input_action.gui_elem_changed,
        defines.input_action.gui_location_changed,
        defines.input_action.gui_selected_tab_changed,
        defines.input_action.gui_selection_state_changed,
        defines.input_action.gui_switch_state_changed,
        defines.input_action.gui_text_changed,
        defines.input_action.gui_value_changed,
        defines.input_action.map_editor_action,
        defines.input_action.open_character_gui,
        defines.input_action.quick_bar_set_selected_page,
        defines.input_action.quick_bar_set_slot,
        defines.input_action.remote_view_surface,
        defines.input_action.set_filter,
        defines.input_action.set_player_color,
        defines.input_action.start_walking,
        defines.input_action.toggle_map_editor,
        defines.input_action.toggle_show_entity_info,
        defines.input_action.write_to_console,
    })

    Permission.apply_permissions('Jail', false)
    Permission.apply_permissions('Jail', true, {
        defines.input_action.edit_permission_group,
        defines.input_action.write_to_console,
    })
end

return Permission