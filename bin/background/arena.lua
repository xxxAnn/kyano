local create_background = require("bin.background.create")
local constants = require("bin.constants")
local clean = require("bin.background.create")

--[[
Simple wrapper for cleaning, then loading the image and creating an arena of the desired size.
]]--
return function (a, b, c, d)
    local amount_x, amount_y, size_x, size_y = a or 3, b or 3, c or 500, d or 500
    clean() -- Clean sprites on the screen, instead of hiding them. They will be collected by the GC in the next cycle.
    local background_tile_img = love.graphics.newImage(constants.IMGP_BACKGROUND)
    create_background(background_tile_img, size_x, size_y, amount_x, amount_y)
end