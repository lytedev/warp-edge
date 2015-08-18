require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local AssetManager = require("assets.assetmanager")
local Gamestate = require("hump.gamestate")
local GUIObject = require("gui.guiobject")
local Timer = require("hump.timer")

-- Globals
debugText = ""
assetManager = AssetManager()
config = config
GUIParent = GUIObject(nil, vector(0, 0), vector(config.window.width, config.window.height), alignments.topleft)

function love.load()
    love.graphics.setColor({17, 255, 17, 255})
    love.window.setIcon(love.image.newImageData("assets/img/logo.png"))

    assetManager:loadFont("opensans_light", 40, "sans40")
    assetManager:loadFont("opensans_light", 32, "sans32")
    assetManager:loadFont("opensans_light", 24, "sans24")
    assetManager:loadFont("pf_tempesta_seven_condensed", 8, "pixel8")
    assetManager:loadFont("pf_tempesta_seven_condensed", 16, "pixel16")
    assetManager:loadFont("pf_tempesta_seven_condensed", 32, "pixel32")
    assetManager:loadFont("pf_westa_seven_condensed", 8, "pxserif8")
    assetManager:loadFont("pf_westa_seven_condensed", 16, "pxserif16")
    assetManager:loadFont("pf_westa_seven_condensed", 32, "pxserif32")

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

    love.graphics.isFullscreened = config.window.fullscreen
    updateLastMousePosition()
end

function love.update(dt)
    Timer.update(dt)
    updateLastMousePosition()
end

function love.keypressed(key)
    if key == "f11" then
        love.graphics.isFullscreened = not love.graphics.isFullscreened
        love.graphics.setFullscreen(love.graphics.isFullscreened)
    end
end

function updateLastMousePosition()
    local lastMouseX, lastMouseY = love.mouse.getPosition()
    lastMousePosition = { x = lastMouseX, y = lastMouseY }
end

function love.graphics.setFullscreen(fs)
    if fs then
        local modes = love.graphics.getModes()
        table.sort(modes, function(a, b) return a.width*a.height > b.width*b.height end)
        print("Fullscreening to " .. modes[1].width .. " x " .. modes[1].height)
        love.graphics.setMode(modes[1].width, modes[1].height, fs, config.window.vsync, config.window.fsaa)
    else
        print("Windowed Mode")
        love.graphics.setMode(config.window.width, config.window.height, config.window.fullscreen, config.window.vsync, config.window.fsaa)
    end
end

function love.draw()
end
