local constants = require("bin.constants")
local SpriteMod = require("bin.sprite")
local load_3x3_terrain = require("bin.load_terrain.3x3arena")

function love.load()
    print(SpriteMod)
    load_3x3_terrain()
end

function love.draw()
    SpriteMod.sprite:draw_all(Sprite)
end

function love.update( dt )
    -- Do stuff with user input
end

