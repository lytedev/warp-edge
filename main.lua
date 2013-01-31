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
lastMousePosition = { 0, 0 }

function love.conf(t)
    t.console = true
end

function love.load()
    GUIParent.children = {}

    spritesheets.death = love.graphics.newImage("assets/img/death.png")

    fonts.title = love.graphics.newFont("assets/ttf/opensans_light.ttf", 40)
    fonts.sans = love.graphics.newFont("assets/ttf/opensans_light.ttf", 20)
    fonts.pixel = love.graphics.newFont("assets/ttf/pf_tempesta_seven_condensed.ttf", 8)
    fonts.pixel2 = love.graphics.newFont("assets/ttf/pf_tempesta_seven_condensed.ttf", 16)
    fonts.pixel4 = love.graphics.newFont("assets/ttf/pf_tempesta_seven_condensed.ttf", 32)
    fonts.pixelserif = love.graphics.newFont("assets/ttf/pf_westa_seven_condensed.ttf", 8)
    fonts.pixelserif2 = love.graphics.newFont("assets/ttf/pf_westa_seven_condensed.ttf", 16)
    fonts.pixelserif4 = love.graphics.newFont("assets/ttf/pf_westa_seven_condensed.ttf", 32)

    local mainMenu = require("gui.menus.mainmenu")
    Gamestate.registerEvents()
    Gamestate.switch(mainMenu)

    local lastMouseX, lastMouseY = love.mouse.getPosition()
    lastMousePosition = { x = lastMouseX, y = lastMouseY }
    love.graphics.setBackgroundColor(11, 11, 11, 255)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    local lastMouseX, lastMouseY = love.mouse.getPosition()
    lastMousePosition = { x = lastMouseX, y = lastMouseY }
end

function love.draw()
end
