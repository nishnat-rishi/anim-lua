local anim = require('anim')

local obj1, obj2

local color = {
  blue = {92/255, 148/255, 237/255},
  red = {237/255, 102/255, 92/255}
}
local font

function love.load()
  font = love.graphics.newFont(14)

  obj1 = {
    pos = {x = 100, y = 100},
    dim = {x = 40, y = 40},
  }

  obj2 = {
    pos = {x = 150, y = 200},
    dim = {x = 40, y = 40},
    text = 1
  }

  anim:attach{
    id='obj2-width',
    obj1,
    to = obj2,
    where = {
      pos = {
        x = {0, love.graphics.getWidth()}
      }
    },
    controls = {
      dim = {
        x = {20, 100}
      }
    },
    smoothness = 1
  }

  anim:attach{
    id='obj2-height',
    obj1,
    to = obj2,
    where = {
      pos = {
        y = {0, love.graphics.getHeight()}
      }
    },
    controls = {
      dim = {
        y = {20, 100}
      }
    },
    smoothness = 1
  }
end

function love.draw()
  love.graphics.setColor(color.red)
  love.graphics.rectangle(
    'fill',
    obj2.pos.x,
    obj2.pos.y,
    obj2.dim.x,
    obj2.dim.y,
    3
  )

  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(
    string.format('%.0d', obj2.text),
    obj2.pos.x,
    obj2.pos.y + (obj2.dim.y - font:getHeight()) / 2,
    obj2.dim.x,
    'center'
  )

  love.graphics.setColor(color.blue)
  love.graphics.rectangle(
    'fill',
    obj1.pos.x,
    obj1.pos.y,
    obj1.dim.x,
    obj1.dim.y,
    3
  )
end

function love.update(dt)
  anim:update(dt)
end

function love.mousereleased(x, y)
  anim:move{
    obj1,
    to = {
      pos = {
        x = x,
        y = y
      },
    },
    fn = anim.fn.SIN,
    duration = 0.5
  }

  anim:move{
    obj2,
    to = {
      text = math.random(100)
    },
    fn = anim.fn.COS,
    duration = 0.5
  }
end