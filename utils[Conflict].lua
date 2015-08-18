local vector = require("hump.vector")
local Class = require("hump.class")

function rerequire(module)
    package.loaded[module] = nil
    return require(module)
end

local __newImage = love.graphics.newImage -- old function
function love.graphics.newImage( ... ) -- new function that sets nearest filter
   local img = __newImage( ... ) -- call old function with all arguments to this function
   img:setFilter( 'nearest', 'nearest' )
   return img
end
function love.graphics.newSmoothImage( ... )
    return __newImage( ... )
end

function string:trim()
  return (self:gsub("^%s*(.-)%s*$", "%1"))
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

alignments = {
    topleft = 1,
    top = 2,
    topright = 3,
    left = 4,
    center = 5,
    right = 6,
    bottomleft = 7,
    bottom = 8,
    bottomright = 9,
}

function toboolean(v)
    return (type(v) == "string" and v == "true") or (type(v) == "number" and v ~= 0) or (type(v) == "boolean" and v)
end

function csvStringToTable(str)
    local csv = csvStringIterator(str)
    local t = {}
    local i = 1
    for k,v in csv do
        t[i] = trim(v)
        i = i + 1
    end
    return t
end

function csvStringIterator(str)
    local s = str
    local commentDelimiter = string.find(s, "#")
    if commentDelimiter == 1 then
        return nil
    elseif commentDelimiter then
        s = s:sub(0, commentDelimiter - 1)
    end
    return string.gmatch(s, "[^,]+")
end

function selectRectangles(position, size, rsize)
    return math.floor((position.x - 0.5) / rsize.x),
        math.floor((position.y - 0.5) / rsize.y),
        math.floor((position.x + 0.5 + size.x) / rsize.x),
        math.floor((position.y + 0.5 + size.y) / rsize.y)
end

function isPointInRect(px, py, x, y, w, h)
    return px >= x and px <= x + w and py >= y and py <= y + h
end

function getAlignedDimensions(position, size, bounds, alignment)
    local dimension = {0, 0, 0, 0}

    if alignment <= 3 then
        dimension[4] = size.y
        dimension[2] = bounds[2] + position.y
    elseif alignment <= 6 then
        dimension[4] = size.y
        dimension[2] = bounds[2] + (bounds[4] / 2) - (dimension[4] / 2) + position.y
    else
        dimension[4] = size.y
        dimension[2] = bounds[2] + bounds[4] - dimension[4] - position.y
    end
    if alignment % 3 == 1 then
        dimension[3] = size.x
        dimension[1] = bounds[1] + position.x
    elseif alignment % 3 == 2 then
        dimension[3] = size.x
        dimension[1] = bounds[1] + (bounds[3] / 2) - (dimension[3] / 2) + position.x
    elseif alignment % 3 == 0 then
        dimension[3] = size.x
        dimension[1] = bounds[1] + bounds[3] - dimension[3] - position.x
    end

    return dimension
end

function getPenetrationVector(pos1, size1, pos2, size2)
    local max1 = pos1 + size1
    local max2 = pos2 + size2

    if pos1.x < max2.x and
        max1.x > pos2.x and
        pos1.y < max2.y and
        max1.y > pos2.y then

    else
        return vector(0, 0)
    end

    local mtd = vector(0, 0)

    local left = pos2.x - max1.x
    local right = max2.x - pos1.x
    local top = pos2.y - max1.y
    local bottom = max2.y - pos1.y

    if left > 0 or right < 0 then return vector(0, 0) end
    if top > 0 or bottom < 0 then return vector(0, 0) end

    if math.abs(left) < right then
        mtd = mtd + vector(left, 0)
    else
        mtd = mtd + vector(right, 0)
    end

    if math.abs(top) < bottom then
        mtd = mtd + vector(0, top)
    else
        mtd = mtd + vector(0, bottom)
    end

    return mtd
end

function getShortLeg(v)
    if math.abs(v.x) < math.abs(v.y) then
        return vector(v.x, 0);
    else
        return vector(0, v.y);
    end
end

function penetrationResolution(v)
    local coeff = 5
    if math.abs(v.x) < math.abs(v.y) then
        local slide = math.abs(v.x / coeff)
        if v.y < 0 then slide = -slide end
        return vector(v.x, slide);
    else
        local slide = math.abs(v.y / coeff)
        if v.x < 0 then slide = -slide end
        return vector(slide, v.y);
    end
end

-- Binds the number within a certain range, allowing for overflow.
function math.wrap(low, n, high) if n<=high and n>=low then return n else return ((n-low)%(high-low))+low end end

-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end

-- Linear interpolation between two numbers.
function lerp(a,b,t) return a+(b-a)*t end

-- Cosine interpolation between two numbers.
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end

