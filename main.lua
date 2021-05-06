local Sprite = require("bin.sprite")

function love.load()
    -- Start game handler here (Load main menu etc.)
    Sprite:__start() -- Nothing past this point, this should be the last call in love.load()
end

function love.draw()
    Sprite:__draw_all()
end

function love.update( dt )
    -- Do stuff with user input
end

