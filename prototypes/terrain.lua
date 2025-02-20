require 'prototypes.noise'

local f = string.format
local starting_radius = 39
local NE = data.raw['noise-expression']
local NF = data.raw['noise-function']

data:extend({
    {
        type = 'noise-expression',
        name = 'moat',
        parameters = { 'x', 'y' },
        expression = f('(abs(y) < %d) + ((y*y) + (x*x) < 4*(%d^2)) - 2*((y*y + x*x) < (0.5 * %d^2))', starting_radius, starting_radius, starting_radius)
    },
    {
        type = 'noise-function',
        name = 'is_roughly_biter_area',
        parameters = { 'x', 'y' },
        expression = 'abs(y) >= 512 + abs(x) * 0.45'
    },
    {
        type = 'noise-expression',
        name = 'starting_concrete',
        parameters = { 'distance', 'map_seed_small' },
        expression = 'if(moat | (distance > 135), -100, 100 * ((distance < 120) + decorative_mix_noise{seed = map_seed_small, input_scale = 1/7}))',
    },
})

--- Water
NF['water_base'].expression = 'if(moat, 100, if((max_elevation >= elevation) & (is_roughly_biter_area{ x = x, y = y } != 1), influence * min(max_elevation - elevation, 1), -inf))'

--- Enemies
NE['enemy_base_probability'].expression = 'is_roughly_biter_area{ x = x, y = y } * (decorative_mix_noise{seed = map_seed_small, input_scale = 1/7} - 0.3)'

--- Resources
NF['resource_autoplace_all_patches'].local_expressions.starting_patches = f('if(x*x + y*y > %d^2, %s, -inf)', starting_radius, NF['resource_autoplace_all_patches'].local_expressions.starting_patches)
NF['resource_autoplace_all_patches'].local_expressions.regular_patches = f('if(x*x + y*y > %d^2, %s, -inf)', starting_radius, NF['resource_autoplace_all_patches'].local_expressions.regular_patches)
for _, ore in pairs({ 'iron-ore', 'copper-ore', 'coal', 'stone' }) do
    data.raw.resource[ore].autoplace.richness_expression = data.raw.resource[ore].autoplace.richness_expression .. ' * ((distance < 224) * 9 + 1)'
end

--- Rocks
NE['rock_noise'].expression = f('clamp(-inf, inf, (distance < 224) * 0.25 + %s) * (x*x + y*y > %d^2)', NE['rock_noise'].expression, starting_radius)

--- Trees
local remove_trees = function(expr)
    return f('if(is_roughly_biter_area{ x = x, y = y}, 0.05, 1) * (x*x + y*y > (%d)^2) * %s', starting_radius, expr)
end
for _, tree in pairs{
    'tree_01',
    'tree_02',
    'tree_02_red',
    'tree_03',
    'tree_04',
    'tree_05',
    'tree_06',
    'tree_06_brown',
    'tree_07',
    'tree_08',
    'tree_08_brown',
    'tree_08_red',
    'tree_09',
    'tree_09_brown',
    'tree_09_red',
    'tree_02',
} do NE[tree].expression = remove_trees(NE[tree].expression) end
NE['tree_dead_desert'].local_expressions.tree_noise = remove_trees(NE['tree_dead_desert'].local_expressions.tree_noise)
NE['tree_dead_desert'].local_expressions.desert_noise = remove_trees(NE['tree_dead_desert'].local_expressions.desert_noise)

--- Concrete
data.raw.tile['refined-concrete'].autoplace = {
    default_enabled = true,
    probability_expression = 'starting_concrete',
    tile_restriction = { 'water' }
}
