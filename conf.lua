config = {}

function love.conf(t)
    t.skipintro = false
    t.skiptogame = false
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
    t.version = "0.9.2"

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

    t.window.scaleHeight = 180 * 1
    t.window.fullscreen = false
    if t.window.fullscreen then
        t.window.width = 1920
        t.window.height = 1080
    else
        t.window.width = 640
        t.window.height = 360
    end
    --t.window.width = 800
    --t.window.height = 600
    t.window.vsync = true
    t.window.fsaa = 0

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
