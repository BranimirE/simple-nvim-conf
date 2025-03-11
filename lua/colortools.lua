local M = {}
function M.hexToHSL(hex)
    -- Remove the "#" if present
    hex = hex:gsub("#", "")

    -- Convert HEX to RGB
    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255

    -- Get the maximum and minimum values of r, g, b
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min

    -- Calculate Lightness (L)
    local l = (max + min) / 2

    -- Calculate Saturation (S)
    local s = 0
    if delta ~= 0 then
        if l < 0.5 then
            s = delta / (max + min)
        else
            s = delta / (2 - max - min)
        end
    end

    -- Calculate Hue (H)
    local h = 0
    if delta ~= 0 then
        if max == r then
            h = (g - b) / delta
        elseif max == g then
            h = 2 + (b - r) / delta
        elseif max == b then
            h = 4 + (r - g) / delta
        end
    end

    -- Convert H to degrees
    h = h * 60
    if h < 0 then
        h = h + 360
    end

    -- Convert S and L to percentages
    s = s * 100
    l = l * 100

    return h, s, l
end

-- Example usage
-- local hex = "#FF4761"
-- local h, s, l = M.hexToHSL(hex)
-- print(string.format("HSL: (%.2f°, %.2f%%, %.2f%%)", h, s, l))


-- Function to convert HSL to HEX
function M.HSLToHex(h, s, l)
    -- Convert percentages to fractions
    s = s / 100
    l = l / 100

    local c = (1 - math.abs(2 * l - 1)) * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = l - c / 2

    local r_prime, g_prime, b_prime = 0, 0, 0

    -- Determine the RGB components based on the hue range
    if h >= 0 and h < 60 then
        r_prime, g_prime, b_prime = c, x, 0
    elseif h >= 60 and h < 120 then
        r_prime, g_prime, b_prime = x, c, 0
    elseif h >= 120 and h < 180 then
        r_prime, g_prime, b_prime = 0, c, x
    elseif h >= 180 and h < 240 then
        r_prime, g_prime, b_prime = 0, x, c
    elseif h >= 240 and h < 300 then
        r_prime, g_prime, b_prime = x, 0, c
    elseif h >= 300 and h < 360 then
        r_prime, g_prime, b_prime = c, 0, x
    end

    -- Convert to RGB by adding m and scaling to [0, 255]
    local r = math.floor((r_prime + m) * 255)
    local g = math.floor((g_prime + m) * 255)
    local b = math.floor((b_prime + m) * 255)

    -- Convert each value to HEX format and return the concatenated result
    return string.format("#%02X%02X%02X", r, g, b)
end

-- Example usage
-- local h, s, l = 11, 67, 60
-- local hex_recovered = HSLToHex(h, s, l)
-- print("HEX:", hex_recovered)

-- Calculed as `saturation + (saturation / 100 * percentage)`
--
-- **Note:** If the result is higher than 100, 100 is used
function M.sature_add_current_percentage(percentage)
    return function (color)
        local h, s, l = M.hexToHSL(color)
        local inc = s / 100 * percentage
        s = math.min(100, s + inc)
        return M.HSLToHex(h, s, l)
    end
end

function M.transform(palette, transformerFn)
    local transformed = {}
    for key, value in pairs(palette) do
        transformed[key] = transformerFn(value)
    end
    return transformed
end

return M
