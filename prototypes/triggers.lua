local function effect(event_id)
    return {
        type = 'direct',
        action_delivery = {
            type = 'instant',
            source_effects = {
                type = 'script',
                effect_id = event_id
            }
        }
    }
end

--- Enemies
data.raw['unit-spawner']['biter-spawner'].created_effect = effect('bb_enemy_entity')
data.raw['unit-spawner']['spitter-spawner'].created_effect = effect('bb_enemy_entity')

for _, name in pairs{ 'small', 'medium', 'big', 'behemoth' } do
    data.raw.turret[name..'-worm-turret'].created_effect = effect('bb_enemy_entity')
end
