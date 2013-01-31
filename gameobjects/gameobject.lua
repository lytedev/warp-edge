require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local GameObject = Class{function(self, position, size)
    self.position = position
    self.size = size
    self.velocity = vector(0, 0)
    self.acceleration = vector(0, 0)
    self.collisionSize = size
    self.collisionOffset = vector(0, 0)
    self.friction = 1
    self.ghost = false
    self.static = false
end}

function GameObject:update(dt)
    if not self.static then
        self.position = self.position + (self.velocity * dt)
        self.velocity = self.velocity * math.abs(self.friction - 1)
        self.velocity = self.velocity + (self.acceleration * dt)
    end
end

function GameObject:collideWith(gobj, fixPosition, fixVelocity)
    local fixPos = fixPosition or true
    local fixVel = fixVelocity or true

    local pv = getPenetrationVector(self.position + self.collisionOffset, self.collisionSize, gobj.position + gobj.collisionOffset, gobj.collisionSize)

    if fixPos and (pv.x ~= 0 or pv.y ~= 0) then
        local lpv = getShortLeg(pv)
        self.position = self.position + lpv

        if fixVel then
            if lpv.x < 0 and self.velocity.x > 0 and pv.x < -1 then self.velocity.x = 0 end
            if lpv.x > 0 and self.velocity.x < 0 and pv.x > 1 then self.velocity.x = 0 end
            if lpv.y < 0 and self.velocity.y > 0 and pv.y < -1 then self.velocity.y = 0 end
            if lpv.y > 0 and self.velocity.y < 0 and pv.y > 1 then self.velocity.y = 0 end
        end
    end
end

function GameObject:draw()

end

return GameObject
