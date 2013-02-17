require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local GameObject = require("gameobjects.gameobject")
local AnimationState = require("animations.animationstate")

local Sprite = Class{inherits = {GameObject, AnimationState}, function(self, image, animationSet, size, position)
    GameObject.construct(self, vector(0, 0), size, position)
    AnimationState.construct(self, image, animationSet, size)
end}

function Sprite:update(dt)
    GameObject.update(self, dt)
    AnimationState.update(self, dt)
end

function Sprite:draw()
    GameObject.draw(self)
    AnimationState.draw(self, self.position)
end

return Sprite
