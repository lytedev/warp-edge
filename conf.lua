config = {}

function love.conf(t)
    t.skipintro = true
    t.skiptogame = true
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
    t.identityVersion = "1.3 Alpha"

    t.release = false -- Are you crazy or something?
    t.console = true

    t.screen.scaleHeight = 180 * 1
    t.screen.fullscreen = false
    if t.screen.fullscreen then
        t.screen.width = 1920
        t.screen.height = 1080
    else
        t.screen.width = 640
        t.screen.height = 360
    end
    --t.screen.width = 800
    --t.screen.height = 600
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
