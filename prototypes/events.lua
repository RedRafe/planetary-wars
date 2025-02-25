local events = {
    'on_map_init',
    'on_map_reset',
    'on_match_started',
    'on_match_finished',
    'on_match_picking_phase',
    'on_match_preparation_phase',
    'on_critical_entity_destroyed',
    'on_player_fed',
}

for _, event_name in pairs(events) do
    data:extend({
        {
            type = 'custom-event',
            name = event_name
        }
    })
end