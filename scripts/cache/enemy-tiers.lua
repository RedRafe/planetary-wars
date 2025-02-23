local sample = 'biter'
local precision = 1

--- Build the interval dictionary
local function create_interval_functions(result_units)
    local transformed_units = {}

    for _, unit in ipairs(result_units) do
        local name = string.replace(unit.unit, '-' .. sample, '')
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
                formula = formula,
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
    for evo = 0, 1000 do
        local normalized_evo = evo / 1000 -- Normalize the evolution level to a 0-1 range

        -- Loop through each entity and their intervals
        for name, intervals in pairs(transformed_units) do
            for _, interval in ipairs(intervals) do
                -- Check if the normalized evolution falls within the interval
                if normalized_evo >= interval.min and normalized_evo <= interval.max then
                    -- Calculate the weight using the formula
                    local weight = interval.formula(normalized_evo) * precision -- Multiply by 100
                    weight = math.ceil(weight) -- Round the weight up

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

--- Compress weighted array bt gcd
local function compress_results(weighted_array)
    -- Function to calculate GCD of two numbers
    local function gcd(x, y)
        while y ~= 0 do
            local temp = y
            y = x % y
            x = temp
        end
        return x
    end

    -- Function to calculate GCD of a table of numbers
    local function gcd_of_list(list)
        local result = list[1]
        for i = 2, #list do
            result = gcd(result, list[i])
        end
        return result
    end

    local function simplify_batches(input)
        -- Step 1: Count occurrences
        local counts = {}
        for _, value in ipairs(input) do
            counts[value] = (counts[value] or 0) + 1
        end

        -- Step 2: Get the counts as a list
        local count_list = {}
        for _, count in pairs(counts) do
            count_list[#count_list + 1] = count
        end

        -- Step 3: Calculate GCD of counts
        local common_divisor = gcd_of_list(count_list)

        -- Step 4: Create the simplified output
        local simplified_result = {}
        for value, count in pairs(counts) do
            for i = 1, math.floor(count / common_divisor) do
                table.insert(simplified_result, value)
            end
        end

        return simplified_result
    end

    local output = {}

    for k, v in pairs(weighted_array) do
        output[k] = simplify_batches(v)
    end

    return output
end

--- Wrapper
local function compute_enemy_tiers()
    local interval_function = create_interval_functions(prototypes.entity[sample .. '-spawner'].result_units)
    local weighted_array = build_weighted_array(interval_function)
    local zip = compress_results(weighted_array)
    return zip
end

return compute_enemy_tiers()
