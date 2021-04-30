local create_background = require("bin.load_terrain.mod")
local constants = require("bin.constants")

return setmetatable({}, {__call = function ()
    local background_tile_img = love.graphics.newImage(constants.IMGP_BACKGROUND)
    create_background(background_tile_img, 500, 500, 3, 3)
end })