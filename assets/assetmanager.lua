require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local AnimationSet = require("animations.animationset")
local AnimationFrame = require("animations.animationframe")
local Animation = require("animations.animation")

local Level = require("level.level")
local Background = require("level.background")
local TileGrid = require("level.tilegrid")
local Tile = require("level.tile")

local AssetManager = Class{function(self)
    local imgData = love.image.newImageData(1, 1)
    imgData:setPixel(0, 0, 0, 0, 0, 0)
    self.blankImage = love.graphics.newImage(imgData)
end}

--[[

# Format Key:

<(requiredVarType)(requiredVarName)>
[(optionalVarType)(optionalVarName)]

## Variable Types:

$ - String
# - Number
^ - Boolean ["true" | "false" (non-case-sensitive), ~0 or 0]

# AnimationSet Format:

<$animationKey>
<*animationFrame1>
[*animationFrame2]
[*animationFrame3]
[*animationFrameN...]

* - AnimationFrame Format:
<#sourceX>, <#sourceY>, [#width], [#height], [#offsetX], [#offsetY], [#

]]--
function AssetManager:loadAnimationFrame(line, defaultFrameSize)
    local defaultFrameSize = defaultFrameSize or vector(16, 16)
    local t = csvStringToTable(line)
    t[1] = tonumber(t[1])
    t[2] = tonumber(t[2])
    t[3] = tonumber(t[3]) or defaultFrameSize.x
    defaultFrameSize.x = t[3]
    t[4] = tonumber(t[4]) or defaultFrameSize.y
    defaultFrameSize.y = t[4]
    t[5] = tonumber(t[5]) or 0
    t[6] = tonumber(t[6]) or 0
    return AnimationFrame(vector(t[1], t[2]), vector(t[3], t[4]), vector(t[5], t[6]), tonumber(t[7]), tonumber(t[7]))
end

function AssetManager:loadAnimationData(line)
        local t = csvStringToTable(line)
        if #t < 1 then
            return nil
        end
        return {key = t[1], animation = Animation({}, tonumber(t[2]) or nil, tonumber(t[3]) or nil, toboolean(t[4]) or nil)}
    end

function AssetManager:loadAnimationSet(file)
    local as = AnimationSet()

    local defaultFrameSize = vector(16, 16)
    local state = nil

    for line in love.filesystem.lines(file) do
        if line:trim() == "" then
            if state ~= nil then
                as:addAnimation(state.key, state.animation)
            end
            state = nil
        elseif state == nil then
            state = self:loadAnimationData(line)
        else
            state.animation:addFrame(self:loadAnimationFrame(line, defaultFrameSize))
        end
    end

    if state ~= nil then
        as:addAnimation(state.key, state.animation)
    end

    return as
end

function AssetManager:loadLevel(file)

end

return AssetManager
