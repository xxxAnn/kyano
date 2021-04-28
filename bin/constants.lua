--[[ Naming: a.b
-> a is the type of variable "IMGP" stands for Image Path, "C" stands for Config ..
-> b is the unique identifier of the variable.

--]]
local consts = {
    IMGP_BASIC = "assets/default.png", -- todo: replace static value with value pulled from XML file.
    IMGP_BACKGROUND =  "assets/background_tile.png",
    -- ..
    __call = function ()
        -- todo: reload constants from XML file.
    end
}

return consts