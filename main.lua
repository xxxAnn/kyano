local constants = require("bin.constants")
local SpriteMod = require("bin.sprite")
local load_arena = require("bin.background.arena")

function love.load()
    -- Start game handler here (Load main menu etc.)
    SpriteMod.sprite:__start() -- Nothing past this point, this should be the last call in love.load()
end

function love.draw()
    SpriteMod.sprite:__draw_all()
end

function love.update( dt )
    -- Do stuff with user input
end

