local anim = require('anim')

local obj1, obj2

local color = {
  blue = {92/255, 148/255, 237/255},
  red = {237/255, 102/255, 92/255}
}

function love.load()
  obj1 = {
    pos = {x = 10, y = 10},
    dim = {x = 20, y = 20},
  }

  obj2 = {
    pos = {x = 200, y = 50},
    dim = {x = 20, y = 20},
  }

  anim:attach{
    id='obj2-width',
    obj1,
    to = obj2,
    where = {
      pos = {
        x = {100, 200}
      }
    },
    controls = {
      dim = {
        x = {20, 100}
      }
    },
    fn = anim.fn.SPIKE
  }

  anim:attach{
    id='obj2-height',
    obj1,
    to = obj2,
    where = {
      pos = {
        y = {100, 200}
      }
    },
    controls = {
      dim = {
        y = {20, 100}
      }
    },
    fn = anim.fn.COS
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

local pressed = false
function love.mousepressed(x, y)
  pressed = true
end

function love.mousemoved(x, y, dx, dy)
  if pressed then
    obj1.pos.x, obj1.pos.y = obj1.pos.x + dx, obj1.pos.y + dy
  end
end

function love.mousereleased(x, y)
  pressed = false
end