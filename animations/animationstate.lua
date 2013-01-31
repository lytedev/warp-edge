local vector = require("hump.vector")
local Class = require("hump.class")

local AnimationState = Class{function(self, animationSet)
    self:reset()
    self.key = animationSet[1]
end}

function AnimationState:reset()
    self.currentFrameID = 1
    self.currentTime = 0
    self.currentFrames = 0

    self.started = false
    self.ended = false
    self.looping = false
    self.bouncing = false
end

return AnimationState
