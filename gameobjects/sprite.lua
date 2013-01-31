local GameObject = require("gameobjects.gameobject")

local Sprite = Class{inherits = GameObject, function(self, image, position, size, animationSet)
    GameObject.construct(self, position, size)
    self.image = image
    self.animationSet = animationSet or nil
    if animationSet then
        self.animationKey = animationSet:getKey()
    else
        self.animationKey = ""
    end
    self.quad = love.graphics.newQuad(0, 0, self.size.x, self.size.y, self.image:getWidth(), self.image:getHeight())

    self.currentFrameID = 1
    self.currentTime = 0
    self.currentFrames = 0

    self.started = false
    self.ended = false
    self.looping = false
    self.bouncing = false
end}

function Sprite:update(dt)
    GameObject.update(self, dt)
    if self.animationSet then
        self.animationSet:update(dt)
        local f = self.animationSet:getCurrentFrame()
        if f then
            self.quad:setViewport(f.offset.x, f.offset.y, f.size.x, f.size.y)
        end
    end
end

function Sprite:draw()
    love.graphics.drawq(self.image, self.quad, self.position.x, self.position.y)
end

return Sprite
