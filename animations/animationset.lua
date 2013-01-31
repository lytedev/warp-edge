require("utils")
local Class = require("hump.class")
local vector = require("hump.vector")
local Animation = require("animations.animation")
local AnimationFrame = require("animations.animationframe")

local AnimationSet = Class{function(self, animationKeysTable)
    self.animations = {}
    self.currentKey = ""
    if animationKeysTable then
        for i = 1, #animationKeysTable, 1 do
            self:addAnimation(animationKeysTable[i].key, animationKeysTable[i].animation)
        end
    end
end}

function AnimationSet:getFrame(key, fid)

end

function AnimationSet:update(dt)
    self:getCurrentAnimation():update(dt)
end

function AnimationSet:updateKey(key, dt)
    self:getAnimation(key):update(dt)
end

function AnimationSet:setKey(key)
    self.currentKey = key
end

function AnimationSet:getKey()
    return self.currentKey
end

function AnimationSet:getCurrentAnimation()
    return self.animations[self.currentKey]
end

function AnimationSet:getAnimation(key)
    return self.animations[key]
end

function AnimationSet:removeAnimation(key)
    self.animations[key] = nil
end

function AnimationSet:addAnimation(key, animation)
    if self.currentKey == "" then
        self:setKey(key)
    end
    self.animations[key] = animation
end

function AnimationSet:getCurrentFrame()
    return self:getCurrentAnimation():getCurrentFrame()
end

return AnimationSet
