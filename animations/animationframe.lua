local vector = require("hump.vector")
local Class = require("hump.class")

local AnimationFrame = Class{function(self, source, size, offset, time, frames)
    self.source = source or vector(0, 0)
    self.size = size or vector(16, 16)
    self.offset = offset or vector(0, 0)
    self.time = time or 0.2
    self.frames = frames or 12
end}

return AnimationFrame
