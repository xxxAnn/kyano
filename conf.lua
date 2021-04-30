local constants = require("bin.constants")

function love.conf(t)
    t.window.width = constants.width
    t.window.height = constants.height
    t.window.title = "Kyano"
end