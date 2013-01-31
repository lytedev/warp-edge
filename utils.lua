local __newImage = love.graphics.newImage -- old function
function love.graphics.newImage( ... ) -- new function that sets nearest filter
   local img = __newImage( ... ) -- call old function with all arguments to this function
   img:setFilter( 'nearest', 'nearest' )
   return img
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
