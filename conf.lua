config = {}

function love.conf(t)
    t.skipinto = false
    t.defaultsettings = true

    -- love.graphics.setBackgroundColor(0, 0, 0, 255)
    if not t.defaultsettings then
        -- settings:load("settings.lua")
    end
    config = t

    t.title = "Warp Edge"
    t.author = "Daniel \"lytedev\" Flanagan"
    t.url = "http://lytedev.com"
    t.identity = "warp_edge"
    t.version = "0.8.0"

    -- Versioning System:
    -- Alpha X.X.X
        -- Non-Functioning Game
    -- Beta X.X.X
        -- Functioning Game, Many Bugs
    -- Release X.X>X
        -- Full Game, Minimal Bugs
    t.identityVersion = "Alpha 1.0"

    t.release = false -- Are you crazy or something?
    t.console = true

    t.screen.scaleHeight = 180
    t.screen.width = 640
    t.screen.height = 360
    t.screen.fullscreen = false
    t.screen.vsync = true
    t.screen.fsaa = 0

    t.modules.joystick = true
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.physics = false
end
