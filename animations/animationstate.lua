require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local AnimationFrame = require("animations.animationframe")

local AnimationState = Class{function(self, image, animationSet, size, initialKey)
    self:reset()
    self.image = image
    self.animationSet = animationSet
    self.key = "default"
    if self.animationSet then
        self.key = animationSet.initialKey
    end
    if initialKey then
        -- print("Initial Key: " .. initialKey)
        self.key = initialKey
    end
    self.size = size or vector(self.image:getWidth(), self.image:getHeight())
    self.overlay = {255, 255, 255, 255}
    self.offset = vector(0, 0)

    self.quad = love.graphics.newQuad(0, 0, self.size.x, self.size.y, self.image:getWidth(), self.image:getHeight())
end}

function AnimationState:reset()
    self.currentFrameID = 1
    self.currentTime = 0
    self.currentFrames = 0

    self.started = false
    self.ended = true
    self.looping = false
    self.bouncing = false
end

function AnimationState:setKey(key)
    self.key = key
    self:reset()
end

function AnimationState:getAnimation()
    if self.animationSet then
        return self.animationSet:getAnimation(self.key)
    else
        return nil
    end
end

function AnimationState:getFrame()
    local a = self:getAnimation()
    if a then
        -- print("Tried to fetch AnimationFrame with nil AnimationSet - returning image dimension frame")
        return a:getFrame(self.currentFrameID)
    else
        return AnimationFrame(vector(0, 0), vector(self.image:getWidth(), self.image:getHeight()))
    end
end

function AnimationState:update(dt)
    self.currentTime = self.currentTime + dt
    self.currentFrames = self.currentFrames + 1

    local a = self:getAnimation()
    if not a then
        return
    end
    if self.currentFrameID > #a.frames then
        self:reset()
    end
    if #a.frames >= 1 and self.currentFrameID >= 1 then
        local f = self:getFrame()
        if self.currentFrames >= f.frames or self.currentTime >= f.time then
            self.currentTime = 0
            self.currentFrames = 0
            self:nextFrame(f, a)
        end
        self.quad:setViewport(f.source.x, f.source.y, f.size.x, f.size.y)
        self.offset = f.offset
    end
end

function AnimationState:nextFrame(currentFrame, currentAnimation)
    if not self.bouncing then
        self.currentFrameID = self.currentFrameID + 1
    else
        if self.currentFrameID > 1 then
            self.currentFrameID = self.currentFrameID - 1
        else
            self.bouncing = false
            self.currentFrameID = self.currentFrameID + 1
        end
    end
    local innerLoopExists = currentAnimation.loopStart > 1 and currentAnimation.loopEnd < #currentAnimation.frames and currentAnimation.loopEnd >= currentAnimation.loopStart;

    if not self.started then
        if self.bouncing then
            if self.currentFrameID <= 1 then
                self.bouncing = false
                -- self.currentFrameID = self.currentFrameID + 1
            end
        else
            self.looping = innerLoopExists and self.currentFrameID >= currentAnimation.loopEnd
            if self.currentFrameID > #currentAnimation.frames or self.looping then
                self.started = true
                self.bouncing = self.bounce
                if not self.bounce and innerLoopExists then
                    self.currentFrameID = currentAnimation.loopStart
                elseif not self.bounce then
                    self.started = false
                    self.currentFrameID = 1
                end
            end
        end
    elseif self.looping and innerLoopExists then
        self.bouncing = not (self.currentFrameID <= currentAnimation.loopStart and self.bouncing)
        if self.currentFrameID >= currentAnimation.loopEnd and not self.bounce then
            self.currentFrameID = currentAnimation.loopStart
        end
    else
        if #currentAnimation.frames >= 1 then
            if self.currentFrameID >= #currentAnimation.frames then
                self.ended = true
                self.started = false
                self.looping = false
                self.bouncing = self.bounce
                if not self.bounce then
                    self.currentFrameID = 1
                end
            end
        end
    end
end

function AnimationState:draw(position)
    love.graphics.setColor(self.overlay)
    love.graphics.drawq(self.image, self.quad, position.x + self.offset.x, position.y + self.offset.y)
end

return AnimationState

--[[

function Animation:nextFrame(currentFrame)
    local m = self.currentTime / currentFrame.time
    self.currentTime = self.currentTime - (m * currentFrame.time)
    self.currentFrames = 0

    if not self.bouncing then
        self.currentFrameID = self.currentFrameID + 1
    else
        if self.currentFrameID > 1 then
            self.currentFrameID = self.currentFrameID - 1
        else
            self.bouncing = false
            self.currentFrameID = self.currentFrameID + 1
        end
    end
    local innerLoopExists = self.loopStart > 1 and self.loopEnd < #self.frames and self.loopEnd >= self.loopStart;

    if not self.started then
        if self.bouncing then
            if self.currentFrameID <= 1 then
                self.bouncing = false
                self.currentFrameID = self.currentFrameID + 1
            end
        else
            self.looping = innerLoopExists and self.currentFrameID >= self.loopEnd
            if self.currentFrameID > #self.frames or self.looping then
                self.started = true
                self.bouncing = self.bounce
                if not self.bounce and innerLoopExists then
                    self.currentFrameID = self.loopStart
                elseif not self.bounce then
                    self.started = false
                    self.currentFrameID = 1
                end
            end
        end
    elseif self.looping and innerLoopExists then
        self.bouncing = not (self.currentFrameID <= self.loopStart and self.bouncing)
        if self.currentFrameID >= self.loopEnd and not self.bounce then
            self.currentFrameID = self.loopStart
        end
    else
        if #self.frames >= 1 then
            if self.currentFrameID >= #self.frames then
                self.ended = true
                self.started = false
                self.looping = false
                self.bouncing = self.bounce
                if not self.bounce then
                    self.currentFrameID = 0
                end
            end
        end
    end
end

]]--
