require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local GameObject = Class{function(self, size, position)
    self.position = position or vector(0, 0)
    self.size = size or vector(16, 16)
    self.velocity = vector(0, 0)
    self.acceleration = vector(0, 0)
    self.collisionSize = self.size
    self.collisionOffset = vector(0, 0)
    self.friction = 1
    self.ghost = false
    self.static = false
    self.facing = vector(0, 0)

    self.onCollideWith = function(g) end
    self.onCollide = function(pos, size) end
end}

function GameObject:copy()

end

function GameObject:update(dt)
    if not self.static then
        if self.velocity.x ~= 0 or self.velocity.y ~= 0 then
            self.lastFacing = vector(self.facing.x, self.facing.y)
            self.facing = self.velocity:normalized()
            if self.facing.x > 0 then self.facing.x = 1
                elseif self.facing.x < 0 then self.facing.x = -1 end
            if self.facing.y > 0 then self.facing.y = 1
                elseif self.facing.y < 0 then self.facing.y = -1 end
        end
        self.position = self.position + (self.velocity * dt)
        self.velocity = self.velocity * math.abs(self.friction - 1)
        self.velocity = self.velocity + (self.acceleration * dt)
    else
        self.velocity = vector(0, 0)
    end
end

function GameObject:collide(position, size, fixPosition, fixVelocity)
    if self.ghost then return false end

    local fixPos = fixPosition or true
    local fixVel = fixVelocity or true

    local pv = getPenetrationVector(self.position + self.collisionOffset, self.collisionSize, position, size)

    if (pv.x ~= 0 or pv.y ~= 0) then
        self:onCollide(position, size)
    end

    if fixPos and (pv.x ~= 0 or pv.y ~= 0) then
        if not self.static then
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

    return pv.x ~= 0 or pv.y ~= 0
end

function GameObject:collideWith(g, fixPosition, fixVelocity)
    if self.ghost or g.ghost then return false end

    local position = g.position + g.collisionOffset
    local size = g.collisionSize

    local fixPos = fixPosition or true
    local fixVel = fixVelocity or true

    local pv = getPenetrationVector(self.position + self.collisionOffset, self.collisionSize, position, size)

    if (pv.x ~= 0 or pv.y ~= 0) then
        self:onCollideWith(g)
        g:onCollideWith(self)
    end

    if fixPos and (pv.x ~= 0 or pv.y ~= 0) then
        if not self.static then
            local lpv = getShortLeg(pv)
            self.position = self.position + (lpv)
            g.position = g.position - (lpv)

            if fixVel then
                --[[
                if lpv.x < 0 and self.velocity.x > 0 and pv.x < -1 then self.velocity.x = 0 end
                if lpv.x > 0 and self.velocity.x < 0 and pv.x > 1 then self.velocity.x = 0 end
                if lpv.y < 0 and self.velocity.y > 0 and pv.y < -1 then self.velocity.y = 0 end
                if lpv.y > 0 and self.velocity.y < 0 and pv.y > 1 then self.velocity.y = 0 end
                ]]--
                --g.velocity = self.velocity / 2
                --self.velocity = -self.velocity / 2
            end
        end

    end

    return pv.x ~= 0 or pv.y ~= 0
end

function GameObject:draw()

end

return GameObject
