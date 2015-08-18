require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local Tile = require("level.tile")

local TileGrid = Class{function(self, width, height, tilesize, tileset)
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
    self.tilesize = tilesize or 16

    self.blankTile = Tile(assetManager.blankImage)

    if type(width) == "userdata" and type(height) == "table" then
        local img = width
        local pxt = height

        local xmax = img:getWidth()
        local ymax = img:getHeight()
        self.size = vector(xmax, ymax)
        self.tiles = {}

        for x = 0, xmax - 1 do
            for y = 0, ymax - 1 do
                local r, g, b, a = img:getPixel(x, y)
                local pixeln = string.format("%i,%i,%i,%i",r,g,b,a)
                local tt = pxt[pixeln] or 0
                self:setTile(x, y, tt)
            end
        end

        return
    end

    local w = width or 32
    local h = height or 32
    self.size = vector(w, h)

    self.tiles = {}

    local i = 1
    for i = 1, self.size.x * self.size.y do
        self:setTileById(i, 0)
    end
end}

function TileGrid:getTileIdFromCoords(x, y)
    x = math.floor(x)
    y = math.floor(y)
    if self:tileExists(x, y) then
        return ((y * self.size.x) + x) + 1;
    else
        return nil
    end
end

function TileGrid:getTileCoordsFromId(id)
    return vector((id - 1) % self.size.x, math.floor((id - 1) / self.size.x))
end

function TileGrid:setTile(x, y, type)
    x = math.floor(x)
    y = math.floor(y)
    if self:tileExists(x, y) then
        self.tiles[self:getTileIdFromCoords(x, y)] = type
    end
end

function TileGrid:setTileById(id, type)
    self.tiles[id] = type
end

function TileGrid:getTileType(x, y)
    x = math.floor(x)
    y = math.floor(y)
    if self:tileExists(x, y) then
        return self.tiles[self:getTileIdFromCoords(x, y)]
    else
        return 0
    end
end

function TileGrid:getTileTypeById(id)
    return self.tiles[id]
end

function TileGrid:getTile(x, y)
    x = math.floor(x)
    y = math.floor(y)
    if self:tileExists(x, y) then
        return self.tileset[self:getTileType(x, y)]
    else
        return self.blankTile
    end
end

function TileGrid:getTileById(id)
    local tileTypeId = self:getTileTypeById(id)
    if tileTypeId ~= 0 then
        return self.tileset[tileTypeId]
    else
        return self.blankTile
    end
end

function TileGrid:selectTileSection(position, size, noclamp)
    local noclamp = noclamp or false
    noclamp = false
    local x1, y1, x2, y2 = selectRectangles(position, size, vector(self.tilesize, self.tilesize))
    if not noclamp then
        x1 = math.clamp(0, x1, self.size.x - 1)
        y1 = math.clamp(0, y1, self.size.y - 1)
        x2 = math.clamp(0, x2, self.size.x - 1)
        y2 = math.clamp(0, y2, self.size.y - 1)
        -- print(TileGrid.numofclamps .. "HEY!")
    end
    return x1, y1, x2, y2
end

function TileGrid:tileExists(x, y)
    return x >= 0 and x < self.size.x and y >= 0 and y < self.size.y
end

function TileGrid:tileExistsById(i)
    return self:tileExists(self:getTileCoordsFromId(i))
end

function TileGrid:collideObjectWithTiles(g)
    local gpposition = g.position + g.collisionOffset
    local x1, y1, x2, y2 = self:selectTileSection(gpposition, g.collisionSize)
    if not x1 or not y1 or not x2 or not y2 then
        return nil
    end

    local tsize = vector(self.tilesize, self.tilesize)

    for x = x1, x2 do
        for y = y1, y2 do

            local t = self:getTile(x, y)
            if t then
                local tryCollide = t.solid and self:tileExists(x, y)

                local leftEdgeDiff = math.abs((x + 1) * self.tilesize - gpposition.x)
                local rightEdgeDiff = math.abs(x * self.tilesize - (gpposition.x + g.collisionSize.x))
                local topEdgeDiff = math.abs((y + 1) * self.tilesize - gpposition.y)
                local edgeDiffSens = 4

                if (leftEdgeDiff < edgeDiffSens or
                    rightEdgeDiff < edgeDiffSens) and
                    topEdgeDiff < edgeDiffSens
                        then
                    tryCollide = false
                end

                if tryCollide then
                    local tpos = vector(x * self.tilesize, y * self.tilesize)
                    if g:collide(tpos, tsize) then

                    end
                    -- print(output)
                end
            end
        end
    end
end

function TileGrid:update(dt)
    for i = 1, #self.tileset do
        self.tileset[i]:update(dt)
    end
end

function TileGrid:draw()
    local max = self.size.x * self.size.y
    for i = 1, max do
        local c = self:getTileCoordsFromId(i)
        local tile = self:getTileById(i)
        tile:draw(c * self.tilesize)
        -- love.graphics.rectangle("line", c.x * self.tilesize, c.y * self.tilesize, self.tilesize, self.tilesize)
    end
end

return TileGrid
