require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local GameObject = require("gameobjects.gameobject")
local AnimationState = require("animations.animationstate")
local Sprite = require("gameobjects.sprite")

local Character = Class{inherits = {Sprite}, function(self, image, animationSet, size, collisionOffset, collisionSize, position, name)
    Sprite.construct(self, image, animationSet, size, position)
    self.name = name or "Character"
    self.collisionOffset = collisionOffset or self.collisionOffset
    self.collisionSize = collisionSize or self.collisionSize
    self.speed = 80
end}

function Character:update(dt)
    Sprite.update(self, dt)
end

function Character:draw()
    Sprite.draw(self)
end

function Character:collideWith(g, fixPos, fixVel)
    GameObject.collideWith(self, g, fixPos, fixVel)
end

return Character
