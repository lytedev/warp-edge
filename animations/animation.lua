require("utils")
local Class = require("hump.class")
local vector = require("hump.vector")
local AnimationFrame = require("animations.animationframe")

local Animation = Class{function(self, frames, loopStart, loopEnd, bounce)
    self.frames = frames or {}

    self.loopStart = loopStart or 0
    self.loopEnd = loopEnd or 0

    self.bounce = bounce or false

    self:reset()
end}

function Animation:getFrame(fid)

end

function Animation:update(dt)
    self.currentTime = self.currentTime + dt
    self.currentFrames = self.currentFrames + 1

    local f = self:getCurrentFrame()
    if f then
        if self.currentTime >= f.time or self.currentFrames >= f.frames then
            self:nextFrame(f)
        end
    end
end

function Animation:reset()
    self.currentFrameID = 1
    self.currentTime = 0
    self.currentFrames = 0

    self.started = false
    self.ended = false
    self.looping = false
    self.bouncing = false
end

function Animation:removeFrame(fid)
    if fid < 1 or fid > #self.frames then return end
    self.frames:remove(fid)
end

function Animation:insertFrame(fid, frame)
    if fid < 1 or fid > #self.frames + 1 then return end
    self.frames[fid] = frame
end

function Animation:addFrame(frame)
    self.frames[#self.frames + 1] = frame
end



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

function Animation:setCurrentFrameID(fid)
    self.currentFrameID = fid
end

function Animation:getCurrentFrameID()
    return self.currentFrameID
end

function Animation:getCurrentFrame()
    if #self.frames >= 1 and self.currentFrameID >= 0 and self.currentFrameID <= #self.frames then
        return self.frames[self.currentFrameID]
    else
        return nil
    end
end

return Animation
