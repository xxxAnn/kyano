local constants = require("bin.constants")

function love.conf(t)
    t.window.width = constants.C_WINDOW_WIDTH
    t.window.height = constants.C_WINDOW_HEIGHT
    t.window.title = "Kyano"
    t.console = constants.C_DEBUG
end