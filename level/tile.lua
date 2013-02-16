require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local AnimationState = require("animations.animationstate")

local Tile = Class{inherits = {AnimationState}, function(self, image, animationSet, size, initialAnimationKey, solid)
    AnimationState.construct(self, image, animationSet, size, initialAnimationKey)
    assert(self.image, "Nil Image Loaded as Tile")

    self.solid = solid or false
end}

function Tile:update(dt)
    AnimationState.update(self, dt)
end

function Tile:draw(pos)
    AnimationState.draw(self, pos)
end

return Tile
