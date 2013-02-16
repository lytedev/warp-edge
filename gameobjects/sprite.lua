local GameObject = require("gameobjects.gameobject")
local AnimationState = require("animations.animationstate")

local Sprite = Class{inherits = {GameObject, AnimationState}, function(self, image, animationSet, position, size)
    GameObject.construct(self, position, size)
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
