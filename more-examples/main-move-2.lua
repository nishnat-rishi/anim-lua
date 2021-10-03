local anim = require('anim')

local obj

local color = {
  blue = {92/255, 148/255, 237/255},
  red = {237/255, 102/255, 92/255}
}
local font

function love.load()
  font = love.graphics.newFont(14)

  obj = {
    pos = {x = 100, y = 100},
    dim = {x = 50, y = 50},
    opacity = 1
  }

end

function love.draw()
  love.graphics.setColor(color.blue[1], color.blue[2], color.blue[3], obj.opacity)
  love.graphics.rectangle(
    'fill',
    obj.pos.x,
    obj.pos.y,
    obj.dim.x,
    obj.dim.y,
    3
  )
end

function love.update(dt)
  anim:update(dt)
end

function love.mousepressed(x, y)
  -- anim:move{
  --   obj, -- the object to be animated
  --   to = { -- final values that the object will hold
  --     pos = {
  --       x = 20,
  --       y = 40
  --     },
  --     opacity = 0.5
  --   },
  -- }

  anim:move{
    id = 'x-move',
    obj,
    to = {
      pos = {
        x = 20,
      }
    },
    fn = anim.fn.SIN
  }
  anim:move{
    id = 'y-move',
    obj,
    to = {
      pos = {
        y = 40,
      }
    },
    duration = 1, -- second(s)
    fn = anim.fn.COS
  }
end