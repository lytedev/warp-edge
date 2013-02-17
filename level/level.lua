require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local Tile = require("level.tile")
local TileGrid = require("level.tilegrid")
local GameObject = require("gameobjects.gameobject")

local Level = Class{function(self, width, height, tilesize, tileset)
    local w = width or 64
    local h = height or 64
    self.size = vector(w, h)
    self.tilesize = tilesize or 16

    self.tileset = tileset or {
        Tile(
            assetManager:getImage("tiles"),
            assetManager:getAnimationSet("tiles"),
            vector(self.tilesize, self.tilesize),
            "mossstone",
            true),
        Tile(
            assetManager:getImage("tiles"),
            assetManager:getAnimationSet("tiles"),
            vector(self.tilesize, self.tilesize),
            "mossstonefloor",
            false)
        }

    self.blankTile = Tile(assetManager.blankImage)

    self.objects = {}
    self.layers = {}
    self.backgrounds = {}
    self.foregrounds = {}
end}

function Level:getTileIdFromCoords(lid, x, y)
    return self.layers[lid]:getTileIdFromCoords(x, y)
end

function Level:getTileCoordsFromId(lid, id)
    return self.layers[lid]:getTileCoordsFromId(id)
end

function Level:setTile(lid, x, y, type)
    return self.layers[lid]:setTile(x, y, type)
end

function Level:setTileById(lid, id, type)
    return self.layers[lid]:setTileById(id, type)
end

function Level:getTileType(lid, x, y)
    return self.layers[lid]:getTileType(x ,y)
end

function Level:getTileTypeById(lid, id)
    return self.layers[lid]:getTileTypeById(id)
end

function Level:getTile(lid, x, y)
    return self.layers[lid]:getTile(x, y)
end

function Level:getTileById(lid, id)
    return self.layers[lid]:getTileById(id)
end

function Level:selectTileSection(lid, position, size, noclamp)
    return self.layers[lid]:selectTileSection(position, size, noclamp)
end

function Level:tileExists(lid, x, y)
    return self.layers[lid]:tileExists(x, y)
end

function Level:tileExistsById(lid, i)
    return self.layers[lid]:tileExistsById(i)
end

function Level:collideObjectWithTiles(lid, g)
    return self.layers[lid]:collideObjectWithTiles(g)
end

function Level:addLayer(tilegrid)
    self.layers[#self.layers + 1] = tilegrid
end

function Level:removeLayer(id)
    table.remove(self.layers, id)
end

function Level:addBackground(bg)
    self.backgrounds[#self.backgrounds + 1] = bg
end

function Level:removeBackground(id)
    table.remove(self.backgrounds, id)
end

function Level:addForeground(bg)
    self.foregrounds[#self.foregrounds + 1] = bg
end

function Level:removeForeground(id)
    table.remove(self.foregrounds, id)
end

function Level:addObject(g)
    self.objects[#self.objects + 1] = g
end

function Level:removeObject(i)
    table.remove(self.objects, i)
end

function Level:addTileType(tileType)
    self.tileset[#self.tileset + 1] = tileType
end

function Level:removeTileType(tileTypeId)
    table.remove(self.tileset, tileTypeId)
end

function Level:update(dt)
    for i = 1, #self.tileset do
        self.tileset[i]:update(dt)
    end

    for i = 1, #self.backgrounds do
        self.backgrounds[i]:update(dt)
    end

    for i = 1, #self.layers do
        self.layers[i]:update(dt)
    end

    local deleteme = {}

    for i = 1, #self.objects do
        if self.objects[i].delete == true then
            deleteme[#deleteme + 1] = i
        end
        self.objects[i]:update(dt)
        for j = i + 1, #self.objects do
            self.objects[i]:collideWith(self.objects[j])
        end
        if #self.layers >= 1 then
            self:collideObjectWithTiles(1, self.objects[i])
        end
        if #self.layers >= 2 then
            self:collideObjectWithTiles(2, self.objects[i])
        end
    end

    for i = 1, #self.foregrounds do
        self.foregrounds[i]:update(dt)
    end

    for i = 1, #deleteme do
        table.remove(self.objects, deleteme[i])
    end
end

function Level:draw()
    local max = self.size.x * self.size.y

    for i = 1, #self.backgrounds do
        self.backgrounds[i]:draw()
    end

    local camera = getCurrentCamera()
    local viewp = vector(love.graphics.getWidth(), love.graphics.getHeight()) / camera.scale
    for j = 1, #self.layers do
        local x1, y1, x2, y2 = self:selectTileSection(j, vector(camera.x, camera.y) - (viewp / 2), viewp)
        -- print(string.format("%i, %i, %i, %i", x1, y1, x2, y2))
        for x = x1, x2 do
            for y = y1, y2 do
                local tile = self:getTile(j, x, y)
                if tile then
                    tile:draw(vector(x, y) * self.tilesize)
                end
            end
        end
    end
    -- love.graphics.rectangle("line", c.x * self.tilesize, c.y * self.tilesize, self.tilesize, self.tilesize)

    for i = 1, #self.objects do
        self.objects[i]:draw()
    end

    for i = 1, #self.foregrounds do
        self.foregrounds[i]:draw()
    end

    --[[
    local player = self.objects[1]
            love.graphics.rectangle("line", player.position.x + player.collisionOffset.x,
                player.position.y + player.collisionOffset.y,
                player.collisionSize.x,
                player.collisionSize.y)

    local x1, y1, x2, y2 = self:selectTileSection(1, player.position + player.collisionOffset, player.collisionSize)
    if not x1 or not y1 or not x2 or not y2 then
        return nil
    end
    local tsize = vector(self.tilesize, self.tilesize)
    for x = x1, x2 do
        for y = y1, y2 do
            love.graphics.setColor({255, 0, 0, 255})
            love.graphics.rectangle("line", x * self.tilesize, y * self.tilesize, self.tilesize, self.tilesize)
        end
    end

    ]]--
end

return Level
