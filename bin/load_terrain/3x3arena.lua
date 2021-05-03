local create_background = require("bin.load_terrain.mod")
local constants = require("bin.constants")
local clean = require("bin.load_terrain.clean")

return function ()
    clean() -- Clean sprites on the screen, instead of hiding them. They will be collected by the GC in the next cycle.
    local background_tile_img = love.graphics.newImage(constants.IMGP_BACKGROUND)
    create_background(background_tile_img, 500, 500, 3, 3)
end