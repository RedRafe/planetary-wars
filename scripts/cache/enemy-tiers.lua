local replace = string.replace
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

return build_weighted_array(create_interval_functions(prototypes.entity[sample..'-spawner'].result_units))