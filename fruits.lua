function newFruit(all_fruit_images, all_fruit_audio, fruit_type)
  local fruit_images = all_fruit_images[fruit_type]
  local images = fruit_images[love.math.random(1, #fruit_images)]
  local image_width, image_height = images[1]:getDimensions()
  local scale = 50 * scale_factor / image_width  
  local width = image_width * scale
  local height = image_height * scale
  local x, y
  
  local touch_item = function(x, y, width, height, item)
    item_x, item_y, item_width, item_height = item.get_pos()
    return x + width > item_x and x < item_x + item_width and
           y + height > item_y and y < item_y + item_height
  end

  while true do
    x = love.math.random(1, window_width)
    y = love.math.random(1, window_height)
    if not touch_item(x, y, width, height, boss) then
      touching = false
      for i, crossbow in ipairs(crossbows) do
        if touch_item(x, y, width, height, crossbow) then
          touching = true
          break
        end
      end
      if not touching then
        break
      end
    end
  end
  
  local self = {
    name = "fruit",
    fruit_type = fruit_type,
    x=x,
    y=y,
    shooter=shooter,
    width=width,
    height=height,
    scale=scale,
    images=images,
    death=0,
    life=3,
    last_shoot=0,
    bang = all_fruit_audio[1],
    spawn = all_fruit_audio[2],
    splat = all_fruit_audio[3],
  }
  
  love.audio.play(self.spawn:clone())
    
  local get_name = function()
    return self.name
  end
  
  local get_type = function()
    return self.fruit_type
  end
 
  local draw_life = function()
    y = self.y - 20 * scale_factor
    size = 10 * scale_factor
    x = self.x + self.width / 2 - (self.life * size) / 2

    for i=1, self.life do
      love.graphics.setColor(1, 0.5, 0.1)
      love.graphics.rectangle("fill", x, y, size, size)
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", x, y, size, size)
      x = x + size
    end
  end  
  
  local remove = function()
    if self.life == 0 and love.timer.getTime() - self.death > SPLAT_REMOVE then
      return true
    end
    return false
  end
    
  local is_dead = function()
    return self.life == 0
  end

  local dead = function()
    self.life = 0
    self.death = love.timer.getTime()
    love.audio.play(self.splat:clone())
  end
    
  local hit = function()
    if self.life > 0 then
        self.life = self.life - 1
        if self.life == 0 then
          dead()
        end
    end
  end

  local draw = function()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.images[4 - self.life], self.x, self.y, 0, self.scale)
    draw_life()
  end
  
  local get_pos = function()
    return self.x, self.y, self.width, self.height
  end
 
  local shoot = function(x, y)
    if is_dead() then
      return
    end
    if love.timer.getTime() - self.last_shoot > FRUIT_SHOOTING then
      self.last_shoot = love.timer.getTime()
      love.audio.play(self.bang:clone())
      direction = math.atan2((self.y + self.height/ 2 - y), (self.x + self.width / 2 - x))
      table.insert(bullets, newBullet(FRUIT_BULLET_SPEED, self.x + self.width / 2, self.y + self.height/ 2, direction, self.namea))
    end
  end
 
  return {
    get_name = get_name,
    get_pos = get_pos,
    hit = hit,
    draw = draw,
    dead = dead,
    is_dead = is_dead,
    shoot = shoot,
    remove = remove,
    get_type = get_type,
  }
end
