require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local Gamestate = require("hump.gamestate")
local Menu = require("gui.menu")
local Label = require("gui.label")
local Button = require("gui.button")
local Fader = require("misc.fader")

local mainMenu = Gamestate.new()

function mainMenu:init()
    self.overlayFader = Fader(0, 0.2, 255, 0)

    self.onSwitchTo = function(self)
        self.overlayFader:reset()
    end

    self.menu = Menu()
    self.menu.position = vector(40, 30)
    local w = fonts.title:getWidth(config.title)
    self.menu.size = vector(w, love.graphics.getHeight() - (self.menu.position.y * 2))

    local title = Label(self.menu, vector(0, 0))
    title.color = {255, 255, 255, 255}
    title.font = fonts.pixelserif4
    title.text = config.title

    local button = Button(self.menu, vector(-self.menu.position.x, 80))
    button.text = "Play"
    button.font = fonts.pixelserif2
    button.padding = vector(self.menu.position.x, 5)
    button.size = vector(w + 40, button.font:getHeight() + button.padding.y * 2)
    button.onSelect = function()
        local game = require("scenes.game")
        Gamestate.switch(game)
    end
    button:focus()

    local button2 = Button(self.menu, button.position + vector(0, button.font:getHeight() + button.padding.y * 3))
    button2.text = "Settings"
    button2.font = button.font
    button2.size = button.size
    button2.padding = button.padding

    local button3 = Button(self.menu, button2.position + vector(0, button.font:getHeight() + button.padding.y * 3))
    button3.text = "Quit"
    button3.font = button.font
    button3.size = button.size
    button3.padding = button.padding
    button3.onSelect = function() love.event.quit() end

    local tvi = require("gui.labels.titleversioninfo")
    tvi:setParent(self.menu)
end

function mainMenu:update(dt)
    self.menu.size = vector(self.menu.size.x, love.graphics.getHeight() - (self.menu.position.y * 2))
    local x, y = love.mouse.getPosition()
    for i = 1, #self.menu.children, 1 do
        local pb = self.menu.children[i]
        if pb:is_a(Button) then
            d = pb:getAlignedDimensions()
            if isPointInRect(x, y, d[1], d[2], d[3], d[4]) then
                pb:focus()
                if love.mouse.isDown("l") then
                    if pb.onSelect then
                        pb.onSelect()
                    end
                end
            end
        end
    end

    self.overlayFader:update(dt)

    self.menu:update(dt)
end

function mainMenu:draw()
    self.menu:draw(dt)

    local r, g, b, a = love.graphics.getBackgroundColor()
    a = self.overlayFader.val
    love.graphics.setColor({r, g, b, a})
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function mainMenu:keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "up" or key == "w" then
        -- TODO Scrolling with keys
    end
end

return mainMenu
