local Enemy = {}

local replace = string.replace
local math_round = math.round
local math_random = math.random
local sample = 'biter'

--- Build the interval dictionary
local function create_interval_functions(result_units)
    local transformed_units = {}

    for _, unit in ipairs(result_units) do
        local name = replace(unit.unit, '-'..sample, '')
        local points = unit.spawn_points
        local intervals = {}

        for i = 1, #points - 1 do
            local left = points[i]
            local right = points[i + 1]

            local min = left.evolution_factor
            local max = right.evolution_factor

            -- Calculate slope (m) and y-intercept (b) for the line:
            local y1 = left.weight
            local y2 = right.weight
            local slope = (y2 - y1) / (right.evolution_factor - left.evolution_factor)
            local intercept = y1 - slope * left.evolution_factor

            -- Create the function for this interval
            local function formula(x)
                return slope * x + intercept
            end

            -- Store the interval and function
            table.insert(intervals, {
                min = min,
                max = max,
                formula = formula
            })
        end

        transformed_units[name] = intervals
    end

    return transformed_units
end

--- Build the weighted array based on the evolved values
local function build_weighted_array(transformed_units)
    local weighted_array = {}

    -- Iterate from 1 to 1000 for each evolution level
    for evo = 1, 1000 do
        local normalized_evo = evo / 1000  -- Normalize the evolution level to a 0-1 range

        -- Loop through each entity and their intervals
        for name, intervals in pairs(transformed_units) do
            for _, interval in ipairs(intervals) do
                -- Check if the normalized evolution falls within the interval
                if normalized_evo >= interval.min and normalized_evo <= interval.max then
                    -- Calculate the weight using the formula
                    local weight = interval.formula(normalized_evo) * 100  -- Multiply by 100
                    weight = math.ceil(weight)  -- Round the weight up

                    -- Insert the name into the output array according to the calculated weight
                    for i = 1, weight do
                        if not weighted_array[evo] then
                            weighted_array[evo] = {}
                        end
                        table.insert(weighted_array[evo], name)
                    end
                end
            end
        end
    end

    return weighted_array
end

local tiers = build_weighted_array(create_interval_functions(prototypes.entity[sample..'-spawner'].result_units))

--- Re-assigns unit-spawners and worms to the respective force when auto-placed
Enemy.on_enemy_entity_created = function(event)
    local entity = event.source_entity
    entity.force = (entity.position.y > 0) and 'north' or 'south'
end

Enemy.on_entity_died = function(event)
    local entity = event.entity
    if not (entity and entity.valid) then
        return
    end

    if entity.type ~= 'unit-spawner' then
        return
    end

    local unit = replace(entity.name, '-spawner')
    local evo = math_round(entity.force.get_evolution_factor() * 1000)
    local spawner_position = entity.position
    local force = entity.force
    local find_non_colliding_position = entity.surface.find_non_colliding_position
    local create_entity = entity.surface.create_entity
    local candidates = tiers[evo]

    for i = 1, math_random(8, 20) do
        local name = candidates[math_random(#candidates)]..'-'..unit
        local position = find_non_colliding_position(name, spawner_position, 8, 1)
        if position then
            create_entity{
                name = name,
                force = force,
                position = position,
            }
        end
    end
end

return Enemy
