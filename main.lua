require("utils")
-- lick = require("lick")

Class = require("hump.class")
Gamestate = require("hump.gamestate")

require("gameobjects.gameobject")
require("gameobjects.sprite")
require("gui.menu")
require("gui.label")
require("gui.button")

keybinds = {
    up = "up", "w",
    down = "down", "s"
}
fonts = {}
spritesheets = {}
animationSets = {}
lastMousePosition = { 0, 0 }

function love.conf(t)
    t.console = true
end

function love.load()
    love.graphics.setIcon(love.graphics.newImage("assets/img/logo.png"))
    print(config.title .. " - v" .. config.identityVersion)
    love.joystick.open(0)
    GUIParent.children = {}

    AssetManager = require("assets.assetmanager")
    assetManager = AssetManager()

    fonts.title = love.graphics.newFont("assets/ttf/opensans_light.ttf", 40)
    fonts.sans = love.graphics.newFont("assets/ttf/opensans_light.ttf", 20)
    fonts.sans32 = love.graphics.newFont("assets/ttf/opensans_light.ttf", 32)
    fonts.sans24 = love.graphics.newFont("assets/ttf/opensans_light.ttf", 24)
    fonts.pixel = love.graphics.newFont("assets/ttf/pf_tempesta_seven_condensed.ttf", 8)
    fonts.pixel2 = love.graphics.newFont("assets/ttf/pf_tempesta_seven_condensed.ttf", 16)
    fonts.pixel4 = love.graphics.newFont("assets/ttf/pf_tempesta_seven_condensed.ttf", 32)
    fonts.pixelserif = love.graphics.newFont("assets/ttf/pf_westa_seven_condensed.ttf", 8)
    fonts.pixelserif2 = love.graphics.newFont("assets/ttf/pf_westa_seven_condensed.ttf", 16)
    fonts.pixelserif4 = love.graphics.newFont("assets/ttf/pf_westa_seven_condensed.ttf", 32)

    --[[ local mainMenu = require("gui.menus.mainmenu")
    Gamestate.registerEvents()
    Gamestate.switch(mainMenu) ]]--

    Gamestate.registerEvents()

    if config.skipintro == true then
        if config.skiptogame == true then
            local game = require("scenes.game")
            Gamestate.switch(game)
        else
            local mainmenu = require("gui.menus.mainmenu")
            Gamestate.switch(mainmenu)
        end
    else
        local intro = require("scenes.intro")
        Gamestate.switch(intro)
    end

    local lastMouseX, lastMouseY = love.mouse.getPosition()
    lastMousePosition = { x = lastMouseX, y = lastMouseY }
    love.graphics.setBackgroundColor(11, 11, 11, 255)
    isFullscreened = config.screen.fullscreen
    -- print("Number of Joysticks: " .. love.joystick.getNumJoysticks())
end

function love.update(dt)
    local lastMouseX, lastMouseY = love.mouse.getPosition()
    lastMousePosition = { x = lastMouseX, y = lastMouseY }
end

function love.keypressed(key)
    if key == "f11" then
        isFullscreened = not isFullscreened
        love.graphics.setFullscreen(isFullscreened)
    end
end

function love.graphics.setFullscreen(fs)
    if fs then
        local modes = love.graphics.getModes()
        table.sort(modes, function(a, b) return a.width*a.height > b.width*b.height end)
        print("Fullscreening to " .. modes[1].width .. " x " .. modes[1].height)
        love.graphics.setMode(modes[1].width, modes[1].height, fs, config.screen.vsync, config.screen.fsaa)
    else
        print("Windowed Mode")
        love.graphics.setMode(config.screen.width, config.screen.height, config.screen.fullscreen, config.screen.vsync, config.screen.fsaa)
    end
end

function love.draw()
end
