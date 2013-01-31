local vector = require("hump.vector")
local Class = require("hump.class")

local AnimationFrame = Class{function(self, offset, size, time, frames)
    self.offset = offset or vector(0, 0)
    self.size = size or vector(16, 16)
    self.time = time or 0.5
    self.frames = frames or 30
end}

return AnimationFrame
