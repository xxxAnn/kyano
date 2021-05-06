local Sprite = require("bin.class")("Sprite")
local logger = require("bin.utils.logs")

Sprite.__sprites = {}
Sprite.__started = false
Sprite.__lytable = {}
Sprite.__buttons = {}
--[[
Placeholder//
]]--
Sprite.type = "default"

function Sprite:INIT(sprite, sx, sy, visible, x, y, r, ly)
    -- Add attributes
    self.sprite = sprite
    self.x = x or 0
    self.y = y or 0
    self.scale_x = sx or 1
    self.scale_y = sy or 1
    self.rotation = r or 0
    self.visible = ( visible == nil and true) or visible
    self.layer = 1 or ly
    table.insert(Sprite.__sprites, self)
    if self.type == "button" then table.insert(Sprite.__buttons, self) end
    return self
end

--[[
Approximates the hitbox of the sprite
A more precise approximation can be given by replacing this default implementation
]]--
function Sprite:get_box()
    local width, height = self.sprite:getPixelDimensions()
    return {x = self.x, y = self.y}, {x = self.x+width, y = self.y+height}
end

function Sprite:draw()
    if self.visible then
        love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.scale_x, self.scale_y)
    end
end

function Sprite:__draw_all()
    if self.__started == false then
        logger.warning("Tried drawing without initializing sprites")
        return -- Accept as valid code // Might not be safe however
    end
    for _, layer in ipairs(self.__lytable) do
        for _, sprite in ipairs(layer) do
            sprite:draw()
        end
    end
end

function Sprite:__start()
    for _, sprite in ipairs(self.__sprites) do
        if self.__lytable[sprite.layer] == nil then self.__lytable[sprite.layer] = {sprite} else
        table.insert(self.__lytable[sprite.layer], sprite) end
    end
    self.__started = true
end

return Sprite