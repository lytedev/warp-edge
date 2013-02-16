require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local Gamestate = require("hump.gamestate")
local Fader = require("misc.fader")
local Logo = require("misc.logo")

local Intro = Gamestate.new()

function Intro:init()
    self.logos = {}
    self.logoFader = Fader(1.8, 0.2, 0, 255, "cos")

    self.currentLogo = 1

    local lytedevLogo = Logo(love.graphics.newImage("assets/img/logos/lytedev.png"), 2.2, {0, 32, 128, 32})

    lytedevLogo.slideFader = Fader(0.2, 1, 32, 96, "cos")
    lytedevLogo.onUpdate = function(self, dt)
        self.slideFader:update(dt)
        local qx, qy, qw, qh = lytedevLogo.quad:getViewport()
        qy = self.slideFader.val
        lytedevLogo.quad:setViewport(qx, qy, qw, qh)
    end

    lytedevLogo.onDraw = function(self)
        --[[ love.graphics.setFont(fonts.sans32)
        local qx, qy, qw, qh = lytedevLogo.quad:getViewport()
        love.graphics.print(".com",
            (love.graphics.getWidth() / 2) + (qw / 2 + 2),
            (love.graphics.getHeight() / 2) + (qh / 2) - 40) ]]--
    end

    lytedevLogo.onFinished = function(self)
        Gamestate.switch(require("gui.menus.mainmenu"))
    end

    self.logos[1] = lytedevLogo
end

function Intro:update(dt)
    self.logos[self.currentLogo]:update(dt)
    self.logoFader:update(dt)
end

function Intro:draw()
    self.logos[self.currentLogo]:draw()
    local r, g, b, a = love.graphics.getBackgroundColor()
    a = self.logoFader.val
    love.graphics.setColor({r, g, b, a})
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

return Intro
