local Tile = require("bin.etc.tile")
local constants = require("bin.constants")

local function create_background(img, size_x, size_y, amount_x, amount_y)
    local total_x = constants.C_WINDOW_WIDTH
    local total_y = constants.C_WINDOW_HEIGHT
    local unit_size_x = size_x/amount_x
    local unit_size_y = size_y/amount_y
    local margin_top = (total_y-size_y)/2
    local margin_left = (total_x-size_x)/2

    for i = 0, amount_x-1 do
        for j = 0, amount_y-1 do
            local background_tile = Tile(img)
            background_tile.x = (margin_left+(unit_size_x*i))
            background_tile.y = (margin_top+(unit_size_x*j))
            background_tile.scale_x = unit_size_x/250
            background_tile.scale_y = unit_size_y/250
        end
    end
end

return create_background