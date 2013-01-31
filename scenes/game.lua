require("utils")
Camera = require("hump.camera")
local GameObject = require("gameobjects.gameobject")
local Sprite = require("gameobjects.sprite")
local Animation = require("animations.animation")
local AnimationSet = require("animations.animationset")
local AnimationFrame = require("animations.animationframe")

local game = Gamestate.new()

function game:init()
    self.camera = Camera(100, 100, 2, 0)

    local test = AnimationSet({
        {key="idledown",
        animation=Animation({
                AnimationFrame(vector(0, 0), vector(16, 24))
            })
        },
        {key="movedown",
        animation=Animation({
                AnimationFrame(vector(0, 0), vector(16, 24)),
                AnimationFrame(vector(16, 0), vector(16, 24))
            })
        },
        {key="idleup",
        animation=Animation({
                AnimationFrame(vector(0, 24), vector(16, 24)),
            })
        },
        {key="moveup",
        animation=Animation({
                AnimationFrame(vector(0, 24), vector(16, 24)),
                AnimationFrame(vector(16, 24), vector(16, 24))
            })
        },
        {key="idleright",
        animation=Animation({
                AnimationFrame(vector(0, 48), vector(16, 24)),
            })
        },
        {key="moveright",
        animation=Animation({
                AnimationFrame(vector(0, 48), vector(16, 24)),
                AnimationFrame(vector(16, 48), vector(16, 24))
            })
        },
        {key="idleleft",
        animation=Animation({
                AnimationFrame(vector(0, 72), vector(16, 24)),
            })
        },
        {key="moveleft",
        animation=Animation({
                AnimationFrame(vector(0, 72), vector(16, 24)),
                AnimationFrame(vector(16, 72), vector(16, 24))
            })
        },
    })

    self.player = Sprite(spritesheets.death, vector(100, 100), vector(16, 24), test)
    self.player.speed = 50
    self.player.collisionOffset = vector(3, 14)
    self.player.collisionSize = vector(10, 10)

    self.enemies = {}
    self:addEnemy()
    self.enemies[1].animationSet = test
end

function game:addEnemy()
    local s = Sprite(spritesheets.death, vector(150, 150), vector(16, 24))
    s.collisionOffset = vector(3, 14)
    s.collisionSize = vector(10, 10)
    self.enemies[#self.enemies + 1] = s
end

function game:update(dt)
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
        self.player.animationSet:setKey("moveleft")
    elseif dir.x > 0.0001 then
        self.player.animationSet:setKey("moveright")
    elseif dir.y < -0.0001 then
        self.player.animationSet:setKey("moveup")
    elseif dir.y > 0.0001 then
        self.player.animationSet:setKey("movedown")
    else
        local s = "idle" .. self.player.animationSet:getKey():sub(5)
        self.player.animationSet:setKey(s)
    end


    dir:normalize_inplace()
    self.player.velocity = dir * self.player.speed
    self.player:update(dt)

    for i = 1, #self.enemies, 1 do
        self.enemies[i]:update(dt)
        self.player:collideWith(self.enemies[i])
    end

    self.camera:lookAt(self.player.position.x + (self.player.size.x / 2), self.player.position.y + (self.player.size.y / 2))
end

function game:draw()
    self.camera:attach()

    for i = 1, #self.enemies, 1 do
        self.enemies[i]:draw()
    end

    self.player:draw()

    self.camera:detach()

    love.graphics.setFont(fonts.pixel)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(love.timer.getFPS(), 5, 5)
end

function game:keypressed(key)

end

return game
