local Sprite = require("bin.class")("Sprite")

Sprite.sprites = {}

function Sprite:__init(sprite, sx, sy, visible, x, y, r)
    -- Add attributes
    self.sprite = sprite
    self.x = x or 0
    self.y = y or 0
    self.scale_x = sx or 1
    self.scale_y = sy or 1
    self.rotation = r or 0
    self.visible = ( visible == nil and true) or visible
    table.insert(Sprite.sprites, self)
    return self
end

function Sprite:draw()
    if self.visible then
        love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.scale_x, self.scale_y)
    end
end

function Sprite:draw_all()
    for i, sprite in ipairs(self.sprites) do
        sprite:draw()
    end
end

local Tile, _ = require("bin.class")("Tile", Sprite)


return {tile = Tile, sprite = Sprite}