# An animation library for LÖVE/Lua

Small library to handle animations.

## Installation

1. Put `anim.lua` in your project folder.

2. Require `anim.lua`:
```lua
    local anim = require('anim')
```

3. Place `anim:update(dt)` in LÖVE's update loop.

```lua
    function love.update(dt)
      anim:update(dt)
    end
```

4. Done!

## Function Reference

### anim:move(...)
<pre><b>
anim:move{  
  obj,  
  to = final_props,
  [id = id,]  
  [duration = duration,]  
  [fn = fn, on_end = on_end,]  
  [while_animating = while_animating]  
}
</b></pre>
Animates `obj` to `final_props`.

Typical usage:
```lua
local obj = {
  pos = {x = 100, y = 100},
  dim = {x = 50, y = 50},
  opacity = 1
}

anim:move{
  obj, -- the object to be animated
  to = { -- final values that the object will hold
    pos = {
      x = 20,
      y = 40
    },
    opacity = 0.5
  },
}
```
![Move Demo](/gifs/move-demo.gif)

`duration` (in seconds) can be passed to change the duration of the animation.

`fn` is a table used to drive the animation. `anim` provides some cool animations, but custom ones can be added as well using `anim:add_fn`.

`id` is a unique internal identifier. By default, the `id` value can be left empty, in which case, `obj` (table reference) will be used as the `id`. This is important because multiple `anim:move` calls on the same `obj` WITHOUT an `id` being specified will result in only the last `anim:move`'s effects to be registered. To resolve this, either group all changes related to a single object together, or if that's not possible, use unique `id` values for conflicting animations:

```lua
-- obj already defined

-- Let's say I want to move x and y coordinates differently
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
```
![Multiple Move Demo](/gifs/move-2-demo.gif)

`on_end` is a function of the form `function(obj) ... end` executed after the animation has ended.

`while_animating` is a function of the form `function(obj) ... end` executed after each frame of the animation.

`obj` in `on_end` and `while_animating` is the object being passed to `anim:move`.

### anim:attach(...)
<pre><b>
anim:attach{
  obj1,
  to = obj2,
  where = input_prop,
  controls = output_props,
  [id = id,]
  [smoothness = smoothness,]
  [fn = fn,]
  [on_end,]
  [while_animating]
}
</b></pre>
Create an attachment between `obj1` and `obj2` where a change in `obj1`'s `input_prop` value will cause a change in `obj2`'s `output_props`.

Typical usage:

```lua
local obj1 = {
  pos = {x = 10, y = 10},
  dim = {x = 20, y = 20},
}

local obj2 = {
  pos = {x = 50, y = 50},
  dim = {x = 20, y = 20},
}

anim:attach{
  obj1, -- source object
  to = obj2, -- reactive object
  where = { -- has to contain a SINGLE range
    pos = {
      x = {100, 300} -- {initial_value, final_value}
    }
  },
  controls = { -- contains one or more reactive ranges
    dim = {
      x = {100, 200},
      y = {100, 200}
    },
    pos = {
      x = {200, 300}
    }
  }
}
```
![Attach Demo](/gifs/attach-demo.gif)

`id` is a unique internal identifier. By default, the `id` value can be left empty, in which case, `obj2` (table reference) will be used as the `id`.
This is important since if two `anim:attach` calls use the same output-object, only the last call's effects would be registered. To fix this, pass a unique ID to each conflicting function call:

```lua
  -- obj1, obj2 already defined

  -- Let's say I want different functions for each coordinate attachment
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
```
![Multiple Attach Demo](/gifs/attach-2-demo.gif)

`smoothness` can be passed to change smoothness of the animation. Higher values equal less jerky animations.

`fn` is a table used to drive the animation. `anim` provides some cool animations, but custom ones can be added as well using `anim:add_fn`.

`on_end` is a function of the form `function(obj2) ... end` executed after `obj2`'s `output_props` take on the end-of-range values. It executes every time `obj2`'s values hit the end. It won't be executed while staying on the end-of-range value.

`while_animating` is a function of the form `function(obj2) ... end` executed each time `obj2`'s `output_props` change in accordance to `obj2`'s `input_prop`.

`obj2` in `on_end` and `while_animating` is the output object being passed to `anim:attach`.


### anim:add_fn(...)
<pre><b>
anim:add_fn(name, fn, initial_value, final_value)
</b></pre>
Adds a new animation function to anim.

Typical usage:

```lua
anim:add_fn(
  'EASE-IN',
  function(x)
    return x * x * x
  end,
  0,
  1
)

...

-- later on 

anim:move{
  obj,
  to = {
    pos = {x = 10}
  },
  fn = anim.fn.EASE_IN
}
```

`name` is used by the user later on to refer to the function.

`fn` is the actual functor.

`initial_value` and `final_value` are the start and end inputs of the range across which `fn`'s values are to be used.

## Additional Notes

- Playing around with the example files is highly recommended.

- By default, the animation function is linear (`anim.fn.LINE`) and duration is `0.5`. These values are overridden if mentioned in `anim:move` or `anim:attach`. But they can also be changed globally by simply adding the following lines near the top of your file:

```lua
    anim.default.duration = 2 -- or any other value in seconds
    anim.default.fn = anim.fn.SIN -- or some other provided/created function
```

- Technically, the library doesn't depend on LÖVE and can be used in other contexts with some creativity. You just have to ensure `anim:update(dt)` gets called with suitable `dt` values.

- This library uses 'clamp' from [rxi/lume](https://github.com/rxi/lume).

- For a somewhat complex application using this, check out: [nishnat-rishi/whatever](https://github.com/nishnat-rishi/whatever).