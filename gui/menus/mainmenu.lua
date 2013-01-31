Gamestate = require("hump.gamestate")
require("gui.menu")
require("gui.label")
require("gui.button")

local mainMenu = Gamestate.new()

function mainMenu:init()
    self.menu = Menu()
    self.menu.position = vector(40, 30)
    local w = fonts.title:getWidth(config.title)
    self.menu.size = vector(w, config.screen.height - (self.menu.position.y * 2))

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

    self.menu:update(dt)
end

function mainMenu:draw()
    self.menu:draw(dt)
end

function mainMenu:keypressed(key)
    if key == "up" or key == "w" then

    end
end

return mainMenu
