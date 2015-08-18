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

  self.assetRoot = "assets/"
  self.imageFolder = "img/"
  self.fontFolder = "font/"
  self.animationFolder = "animation/"
  self.gameObjectFolder = "gameobject/"
  self.levelFolder = "level/"

  self.images = {}
  self.fonts = {}
  self.animationSets = {}
end}

function AssetManager:clearCache()
  self:clearImages()
  self:clearFonts()
  self:clearAnimationSets()
end

function AssetManager:clearImages()
  self.image = {}
end

function AssetManager:clearFonts()
  self.fonts = {}
end

function AssetManager:clearAnimationSets()
  self.animationSets = {}
end

function AssetManager:getImage(key)
  return self.images[key]
end

function AssetManager:getFont(key)
  return self.fonts[key]
end

function AssetManager:getAnimationSet(key)
  return self.animationSets[key]
end

function AssetManager:loadImage(file, key)
  local key = key or file
  file = string.gsub(file, "[\\.]", "/")
  if not self.images[key] then
    self.images[key] = love.graphics.newImage(self.assetRoot .. self.imageFolder .. file .. ".png")
  end
  return self.images[key]
end

function AssetManager:loadFont(file, size, key)
  local key = key or (file .. tostring(size))
  file = string.gsub(file, "\\.", "/")
  if not self.fonts[key] then
    self.fonts[key] = love.graphics.newFont(self.assetRoot .. self.fontFolder .. file .. ".ttf", size)
  end
  return self.fonts[key]
end

function AssetManager:createImagePath(file)
  return (self.assetRoot .. self.imageFolder .. string.gsub(file, "[\\.]", "/") .. ".png")
end

--[[

# Format Key

## Variable Indicators

<> - Required variable
[] - Optional variable
<[]> - Required if the following optional variable is specified
[<>] - Required if the previous optional variable is specified

## Variable Types

$ - String
# - Number
^ - Boolean ["true" | "false" (non-case-sensitive), ~0 or 0]
* - Table (see variable name for type - example: animationFrame2 implies an AnimationFrame table)
No Type - Must appear exactly as denoted (Example: [layer] indicates that the string "layer" at this point in the file is optional.)

## Variable Formats

<(type)(name)>
[(type)(name)]
<[(type)(name)]>

]]--

--[[

* - AnimationFrame Format
<#sourceX>, <#sourceY>, [#width], [#height], [#offsetX], [#offsetY]

]]--

function AssetManager:parseAnimationFrame(line, defaultFrameSize)
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

function AssetManager:parseAnimationData(line)
  local t = csvStringToTable(line)
  if #t < 1 then
    return nil
  end
  return {key = t[1], animation = Animation({}, tonumber(t[2]) or nil, tonumber(t[3]) or nil, toboolean(t[4]) or nil)}
end

--[[

# AnimationSet Format

<$animationKey>
<*animationFrame1>
[*animationFrame2]
[*animationFrame3]
[*animationFrameN...]

]]--

function AssetManager:loadAnimationSet(file, key)
  local key = key or file
  file = string.gsub(file, "\\.", "/")
  if self.animationSets[key] then
    return self.animationSets[key]
  end

  local as = AnimationSet()

  local defaultFrameSize = vector(16, 16)
  local state = nil

  for line in love.filesystem.lines(self.assetRoot .. self.animationFolder .. file .. ".dat") do
    if line:trim() == "" then
      if state ~= nil then
        as:addAnimation(state.key, state.animation)
      end
      state = nil
      elseif state == nil then
        state = self:parseAnimationData(line)
      else
        state.animation:addFrame(self:parseAnimationFrame(line, defaultFrameSize))
      end
    end

    if state ~= nil then
      as:addAnimation(state.key, state.animation)
    end

    self.animationSets[key] = as
    return as
  end

  --[[

  # Tile Format

  <$imageFile>, <$animationSet>, [$initialAnimationKey], [^solidity],
  [#overlayR], <[#overlayG]>, <[#overlayB]>, <[#overlayA]>

  ]]--

  function AssetManager:parseTile(line, size)
    local t = csvStringToTable(line)
    if not t[4] then
      t[4] = "false"
    end
    t[4] = toboolean(t[4])

    local overlayIndex = 5
    local olr = tonumber(t[overlayIndex]) or 255
    local olg = tonumber(t[overlayIndex + 1]) or 255
    local olb = tonumber(t[overlayIndex + 2]) or 255
    local ola = tonumber(t[overlayIndex + 3]) or 255

    print(t[1])
    local tile = Tile(self:getImage(t[1]),
    self:getAnimationSet(t[2]),
    size, t[3], t[4])
    tile.overlay = {olr, olg, olb, ola}
    return tile
  end

  --[[

  # Background Format

  <$imageFile>, <$animationSet>, [#sizeX], [#sizeY], [$initialAnimationKey],
  [#slideX], [#slideY], [#parallax], [^flipX], [^flipY], [#offsetX], [#offsetY],
  [#overlayR], <[#overlayG]>, <[#overlayB]>, <[#overlayA]>

  ]]--

  function AssetManager:parseBackground(line)
    local t = csvStringToTable(line)
    local image = self:getImage(t[1])
    t[3] = tonumber(t[3]) or image:getWidth()
    t[4] = tonumber(t[4]) or image:getHeight()
    local size = vector(t[3], t[4])
    t[6] = tonumber(t[6]) or 0
    t[7] = tonumber(t[7]) or 0
    local slide = vector(t[6], t[7])
    local parallax = tonumber(t[8]) or 1
    local flipX = toboolean(t[9]) or false
    local flipY = toboolean(t[10]) or false
    t[11] = tonumber(t[11]) or 0
    t[12] = tonumber(t[12]) or 0
    local offset = vector(t[11], t[12])

    local overlayIndex = 13
    local olr = tonumber(t[overlayIndex]) or 255
    local olg = tonumber(t[overlayIndex + 1]) or 255
    local olb = tonumber(t[overlayIndex + 2]) or 255
    local ola = tonumber(t[overlayIndex + 3]) or 255

    local bg = Background(image, self:getAnimationSet(t[2]), size, t[5], slide, parallax, flipX, flipY, offset)
    bg.overlay = {olr, olg, olb, ola}
    return bg
  end


  --[[

  # GameObject Format

  <$gameObjectFile>, [#positionX], [#positionY]

  ]]--

  function AssetManager:loadGameObject(line)
    local t = csvStringToTable(line)
    local go = rerequire(self.assetRoot .. self.gameObjectFolder .. t[1])
    local x = tonumber(t[2]) or 0
    local y = tonumber(t[3]) or 0
    go.position = vector(x, y)
    return go
  end

  --[[

  # Level Format

  ## Notes

  - Blank lines seperate sections, so make note of them.
  - Sections may appear in any order. Layers are added in the order given.

  ## Format

  <#width>, <#height>, <#tilesize>
  [*tileType1]
  [*tileType2]
  [*tileType3]
  [*tileTypeN...]

  [objects]
  <[*gameObject1]>
  [*gameObject2]
  [*gameObject3]
  [*gameObjectN...]

  [backgrounds]
  <[*background1]>
  [*background2]
  [*background3]
  [*backgroundN...]

  [foregrounds]
  <[*foreground1]>
  [*foreground2]
  [*foreground3]
  [*foregroundN...]

  [layer]
  <[#tileTypeId0by0]>, [#tileTypeId1by0], [#tileTypeId2by0], [#tileTypeIdN...by0]
  [#tileTypeId0by1], [#tileTypeId1by1], [#tileTypeId2by1], [#tileTypeIdN...by1]
  [#tileTypeId0by2], [#tileTypeId1by2], [#tileTypeId2by2], [#tileTypeIdN...by2]
  [#tileTypeId0byN...], [#tileTypeId1byN...], [#tileTypeId2byN...], [#tileTypeIdN...byN...]

  [imglayer], <[$imageFile]>
  [#r1], <[#g1]>, <[#b1]>, <[#a1]>, <[#tileTypeId1]>
  [#r2], <[#g2]>, <[#b2]>, <[#a2]>, <[#tileTypeId2]>
  [#r3], <[#g3]>, <[#b3]>, <[#a3]>, <[#tileTypeId3]>
  [#rN...], <[#gN...]>, <[#bN...]>, <[#aN...]>, <[#tileTypeIdN...]>

  ]]--

  function AssetManager:loadLevel(file)
    local state = nil

    for line in love.filesystem.lines(self.assetRoot .. self.levelFolder .. file .. ".dat") do
      if line:trim() == "" then
        if state.section == "layer" then
          state.level:addLayer(state.tilegrid)
          elseif state.section == "imglayer" then
            state.level:addLayer(TileGrid(state.ilayerImage, state.pixelTypes, state.level.tilesize))
            self.images["__level_layer_tmp"] = nil
          end
          state.section = ""
        else
          local t = csvStringToTable(line)
          if t == nil then

            elseif state == nil then
              state = {}
              t[1] = tonumber(t[1])
              t[2] = tonumber(t[2])
              t[3] = tonumber(t[3])
              state.level = Level(t[1], t[2], t[3], {})
              state.section = "tiletypes"
            else
              if state.section == "" then
                state.section = t[1]
                if state.section == "layer" then
                  state.y = 0
                  state.tilegrid = TileGrid(state.level.size.x, state.level.size.y, state.level.tilesize, state.level.tileset)
                end
                if state.section == "imglayer" then
                  state.pixelTypes = {}
                  state.ilayerImage = love.image.newImageData(self:createImagePath(t[2]))
                end
              else
                if state.section == "tiletypes" then
                  local tile = self:parseTile(line, vector(state.level.tilesize, state.level.tilesize))
                  state.level:addTileType(tile)
                  elseif state.section == "objects" then
                    state.level:addObject(self:loadGameObject(line))
                    elseif state.section == "backgrounds" then
                      state.level:addBackground(self:parseBackground(line))
                      elseif state.section == "foregrounds" then
                        state.level:addForeground(self:parseBackground(line))
                        elseif state.section == "layer" then
                          for i = 1, #t do
                            local tid = tonumber(t[i]) or 0
                            state.tilegrid:setTile(i - 1, state.y, tid)
                          end
                          state.y = state.y + 1
                          elseif state.section == "imglayer" then
                            local r = tonumber(t[1])
                            local g = tonumber(t[2])
                            local b = tonumber(t[3])
                            local a = tonumber(t[4])
                            local t = tonumber(t[5])
                            local pixeln = string.format("%i,%i,%i,%i",r,g,b,a)
                            state.pixelTypes[pixeln] = t
                          end
                        end
                      end
                    end
                  end

                  if state then
                    if state.section == "layer" then
                      state.level:addLayer(state.tilegrid)
                      elseif state.section == "imglayer" then
                        state.level:addLayer(TileGrid(state.ilayerImage, state.pixelTypes, state.level.tilesize))
                        self.images["__level_layer_tmp"] = nil
                      end

                      return state.level
                    end

                    return nil
                  end

                  return AssetManager
