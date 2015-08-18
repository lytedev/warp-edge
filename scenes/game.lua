require("utils")
local vector = require("hump.vector")
local Class = require("hump.class")

local Gamestate = require("hump.gamestate")
local Camera = require("hump.camera")
local GameObject = require("gameobjects.gameobject")
local Sprite = require("gameobjects.sprite")
local Character = require("gameobjects.character")
local Animation = require("animations.animation")
local AnimationSet = require("animations.animationset")
local AnimationState = require("animations.animationstate")
local AnimationFrame = require("animations.animationframe")
local Level = require("level.level")
local Background = require("level.background")
local Timer = require("hump.timer")

local game = Gamestate.new()

function game:init()
  self.camera = Camera(100, 100, 2, 0)

  local deathImg = assetManager:loadImage("death")
  local tilesImg = assetManager:loadImage("tiles")

  local grassbgImg = assetManager:loadImage("background.grass1")
  local dm1bgImg = assetManager:loadImage("background.darkmagic1")
  local spcebgImg = assetManager:loadImage("background.space1")
  local cmtsbgImg = assetManager:loadImage("background.comets1")

  local deathAnimS = assetManager:loadAnimationSet("death")
  local tilesAnimS = assetManager:loadAnimationSet("tiles")

  self.player = Character(deathImg, deathAnimS, vector(16, 24), vector(3, 14), vector(10, 10))

  self.level = assetManager:loadLevel("test")
  debugText = ""
  self.level:addObject(self.player)
  --[[

  self.level:addObject(self.player)
  self:addEnemy()

  self.level:setTile(1, 5, 5, 1)
  self.level:setTile(1, 5, 2, 1)
  self.level:setTile(1, 2, 2, 1)
  for x = 0, 32 do
  for y = 0, 32 do
  if x == 0 or x == 31 or y == 0 or y == 31 then
  self.level:setTile(1, x, y, 1)
  end
  end
  end
  self.level:setTile(1, 0, 0, 0)

  local bg4 = Background(spcebgImg)
  self.level:addBackground(bg4)
  bg4.overlay = {100, 150, 255, 255}
  bg4.slide = vector(3, 4)
  bg4.offset = vector(90, 400)

  local bg1 = Background(dm1bgImg)
  self.level:addBackground(bg1)
  bg1.overlay = {255, 0, 255, 50}
  bg1.slide = vector(40, 30)

  local bg2 = Background(cmtsbgImg)
  -- self.level:addForeground(bg2)
  bg2.overlay = {0, 150, 255, 255}
  bg2.slide = vector(450, 40)

  local bg3 = Background(cmtsbgImg)
  -- self.level:addForeground(bg3)
  bg3.overlay = {255, 150, 0, 255}
  bg3.slide = vector(400, 40)
  bg3.offset = vector(90, 400)--]]
end

function game:addEnemy()
  self.level:addObject(assetManager:loadGameObject("enemy.ghost"))
end

function game:update(dt)
  self.camera:zoomTo(love.graphics.getHeight() / config.window.scaleHeight)

  --[[ debugText = ""

  local axes = {}
  local numAxes = love.joystick.getNumAxes(1)
  local output = "Axes: "
  for i = 1, numAxes do
  axes[i] = love.joystick.getAxis(1, i)
  output = string.format("%s%i, ", output, axes[i])
  end

  local buttons = {}
  local numButtons = love.joystick.getNumButtons(1)
  output = output .. "\nButtons: "
  for i = 1, numButtons do
  buttons[i] = love.joystick.isDown(1, i)
  output = string.format("%s%s, ", output, tostring(buttons[i]))
  end

  local hats = {}
  local numHats = love.joystick.getNumHats(1)
  output = output .. "\nHats: "
  for i = 1, numHats do
  hats[i] = love.joystick.getHat(1, i)
  output = string.format("%s%s, ", output, hats[i])
  end

  local numButtons = love.joystick.getNumButtons(1)
  output = output .. "\nButtons: " .. love.joystick.getNumButtons(1)

  debugText = debugText .. output ]]--

  local dir = vector(0, 0)

  if love.keyboard.isDown("w", "up") then
    dir.y = dir.y - 1
  end
  if love.keyboard.isDown("s", "down") then
    dir.y = dir.y + 1
  end
  if love.keyboard.isDown("a", "left") then
    dir.x = dir.x - 1
  end
  if love.keyboard.isDown("d", "right") then
    dir.x = dir.x + 1
  end


  if dir.x < -0.0001 then
    self.player.key = "moveleft"
    elseif dir.x > 0.0001 then
      self.player.key = "moveright"
      elseif dir.y < -0.0001 then
        self.player.key = "moveup"
        elseif dir.y > 0.0001 then
          self.player.key = "movedown"
        else
          local s = "idle" .. self.player.key:sub(5)
          self.player.key = s
        end

        dir:normalize_inplace()
        self.player.velocity = dir * self.player.speed
        if love.keyboard.isDown("lshift") then
          AnimationState.update(self.player, dt)
          self.player.velocity = dir * self.player.speed * 2
        end

        if love.mouse.isDown("l") or love.mouse.isDown("r") then
          local x, y = self.camera:mousepos()
          x = x / self.level.tilesize
          y = y / self.level.tilesize
          local t = 1
          if love.mouse.isDown("r") then
            t = 2
          end
          self.level:setTile(#self.level.layers, x, y, t)
        end
        --[[
        if love.keyboard.isDown("m") and not self.player.cantShoot then
        local db = assetManager:loadGameObject("enemy.deathbolt")
        local offset = vector(self.player.facing.x * (db.collisionSize.x), self.player.facing.y * (db.collisionSize.y))
        db.position = self.player.position + offset + self.player.collisionOffset
        db.velocity = self.player.facing * db.speed
        db.key = "deathbolt"

        if db.velocity.x > 0.0001 then
        db.key = db.key .. "left"
        elseif db.velocity.x < -0.0001 then
        db.key = db.key .. "right"
        elseif db.velocity.y < -0.0001 then
        db.key = db.key .. "up"
        elseif db.velocity.y > 0.0001 then
        db.key = db.key .. "down"
        end

        self.level:addObject(db)
        self.player.cantShoot = true

        player = self.player
        Timer.add(1, function() player.cantShoot = nil end)
        end
        ]]--

        self.level:update(dt)

        -- self.camera:lookAt(math.floor(self.player.position.x + (self.player.size.x / 2) + 0.5), math.floor(self.player.position.y + (self.player.size.y / 2) + 0.5))
        self.camera:lookAt((self.player.position.x + (self.player.size.x / 2)), (self.player.position.y + (self.player.size.y / 2)))
      end

      function game:draw()
        self.camera:attach()

        self.level:draw()

        local camera = getCurrentCamera()
        self.camera:detach()

        love.graphics.setFont(assetManager:getFont("pixel8"))
        love.graphics.setColor(255, 255, 255, 255)

        love.graphics.setColor({255, 255, 255, 255})
        love.graphics.setFont(assetManager:getFont("pixel8"))
        debugText = debugText .. "FPS: " .. love.timer.getFPS() .. "\n"
        love.graphics.print(debugText, 5, 5)
        debugText = ""
      end

      function game:keypressed(key)
        if key == "escape" then
          Gamestate.switch(require("gui.menus.mainmenu"))
        end
        if key == "m" then
          local db = assetManager:loadGameObject("enemy.deathbolt")
          local offset = vector(self.player.facing.x * (db.collisionSize.x), self.player.facing.y * (db.collisionSize.y))
          db.position = self.player.position + offset
          if self.player.facing.y ~= 0 then
            db.position = db.position + vector(2, 0)
          end
          if self.player.facing.y > 0 then
            db.position = db.position + vector(0, self.player.size.y / 1.5)
          end
          db.key = "deathbolt"

          db.velocity = self.player.facing:normalize_inplace() * db.speed
          if db.velocity.x > 0.0001 then
            db.key = db.key .. "left"
            db.velocity.y = 0
            elseif db.velocity.x < -0.0001 then
              db.key = db.key .. "right"
              db.velocity.y = 0
              elseif db.velocity.y < -0.0001 then
                db.key = db.key .. "up"
                db.velocity.x = 0
                elseif db.velocity.y > 0.0001 then
                  db.key = db.key .. "down"
                  db.velocity.x = 0
                end

                self.level:addObject(db)
                self.player.cantShoot = true

                --player = self.player
                --Timer.add(1, function() player.cantShoot = nil end)
              end
            end

            return game
