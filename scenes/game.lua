require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local Gamestate = require("hump.gamestate")
local Camera = require("hump.camera")
local GameObject = require("gameobjects.gameobject")
local Sprite = require("gameobjects.sprite")
local Animation = require("animations.animation")
local AnimationSet = require("animations.animationset")
local AnimationState = require("animations.animationstate")
local AnimationFrame = require("animations.animationframe")
local Level = require("level.level")
local Background = require("level.background")

local game = Gamestate.new()

function game:init()
    self.camera = Camera(100, 100, 2, 0)

    spritesheets.death = love.graphics.newImage("assets/img/death.png")
    spritesheets.tiles = love.graphics.newImage("assets/img/tiles.png")

    animationSets.death = assetManager:loadAnimationSet("assets/animations/death.dat")
    animationSets.tiles = assetManager:loadAnimationSet("assets/animations/tiles.dat")

    self.player = Sprite(spritesheets.death, animationSets.death, vector(0, 0), vector(16, 24))
    self.player.speed = 80
    self.player.collisionOffset = vector(3, 14)
    self.player.collisionSize = vector(10, 10)
    self.player.position = self.player.position - self.player.collisionOffset

    self.level = Level()

    debugText = ""

    self.level:addObject(self.player)
    self:addEnemy()

    self.level:setTile(1, 5, 5, 1)
    self.level:setTile(1, 5, 2, 1)
    self.level:setTile(1, 2, 2, 1)
    for x = 0, 32 do
        for y = 0, 32 do
            if x == 0 or x == 31 or y == 0 or y == 31 then
                self.level:setTile(1, x, y, 1)
            end
        end
    end
    self.level:setTile(1, 0, 0, 0)

    local bg1 = Background(love.graphics.newImage("assets/img/level/bg/darkmagic1.png"))
    self.level:addBackground(bg1)
    bg1.overlay = {255, 0, 255, 20}
    bg1.slide = vector(40, 30)

    local bg2 = Background(love.graphics.newImage("assets/img/level/bg/comets1.png"))
    self.level:addForeground(bg2)
    bg2.overlay = {0, 150, 255, 255}
    bg2.slide = vector(450, 40)

    local bg3 = Background(love.graphics.newImage("assets/img/level/bg/comets1.png"))
    self.level:addForeground(bg3)
    bg3.overlay = {255, 150, 0, 255}
    bg3.slide = vector(400, 40)
    bg3.offset = vector(90, 400)
end

function game:addEnemy()
    local s = Sprite(spritesheets.death, animationSets.death, vector(150, 150), vector(16, 24))
    s.collisionOffset = vector(3, 14)
    s.collisionSize = vector(10, 10)
    s.static = false
    s.ghost = false
    self.level:addObject(s)
end

function game:update(dt)
    self.camera:zoomTo(love.graphics.getHeight() / config.screen.scaleHeight)

    --[[ debugText = ""

    local axes = {}
    local numAxes = love.joystick.getNumAxes(1)
    local output = "Axes: "
    for i = 1, numAxes do
        axes[i] = love.joystick.getAxis(1, i)
        output = string.format("%s%i, ", output, axes[i])
    end

    local buttons = {}
    local numButtons = love.joystick.getNumButtons(1)
    output = output .. "\nButtons: "
    for i = 1, numButtons do
        buttons[i] = love.joystick.isDown(1, i)
        output = string.format("%s%s, ", output, tostring(buttons[i]))
    end

    local hats = {}
    local numHats = love.joystick.getNumHats(1)
    output = output .. "\nHats: "
    for i = 1, numHats do
        hats[i] = love.joystick.getHat(1, i)
        output = string.format("%s%s, ", output, hats[i])
    end

    local numButtons = love.joystick.getNumButtons(1)
    output = output .. "\nButtons: " .. love.joystick.getNumButtons(1)

    debugText = debugText .. output ]]--

    local dir = vector(0, 0)

    if love.keyboard.isDown("w", "up") then
        dir.y = dir.y - 1
    end
    if love.keyboard.isDown("s", "down") then
        dir.y = dir.y + 1
    end
    if love.keyboard.isDown("a", "left") then
        dir.x = dir.x - 1
    end
    if love.keyboard.isDown("d", "right") then
        dir.x = dir.x + 1
    end


    if dir.x < -0.0001 then
        self.player.key = "moveleft"
    elseif dir.x > 0.0001 then
        self.player.key = "moveright"
    elseif dir.y < -0.0001 then
        self.player.key = "moveup"
    elseif dir.y > 0.0001 then
        self.player.key = "movedown"
    else
        local s = "idle" .. self.player.key:sub(5)
        self.player.key = s
    end

    dir:normalize_inplace()
    self.player.velocity = dir * self.player.speed
    if love.keyboard.isDown("lshift") then
        AnimationState.update(self.player, dt)
        self.player.velocity = dir * self.player.speed * 2
    end

    if love.mouse.isDown("l") or love.mouse.isDown("r") then
        local x, y = self.camera:mousepos()
        x = x / self.level.tilesize
        y = y / self.level.tilesize
        local t = 1
        if love.mouse.isDown("r") then
            t = 2
        end
        self.level:setTile(1, x, y, t)
    end

    self.level:update(dt)

    self.camera:lookAt(self.player.position.x + (self.player.size.x / 2), self.player.position.y + (self.player.size.y / 2))
end

function game:draw()
    self.camera:attach()

    self.level:draw()

    self.camera:detach()

    love.graphics.setFont(fonts.pixel)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(love.timer.getFPS(), 5, 5)

    love.graphics.print(debugText, 5, 15)
    debugText = ""
end

function game:keypressed(key)
    if key == "escape" then
        Gamestate.switch(require("gui.menus.mainmenu"))
    end
end

return game
