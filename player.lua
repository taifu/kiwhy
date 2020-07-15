function newPlayer(image, x, y, bang)
  local width, height = image:getDimensions()
  local scale = 50 * scale_factor / width
  
  local self = {
    name = "player",
    life = PLAYER_LIFE,
    image = image,
    width = width * scale,
    height = height * scale,
    scale = scale,
    speed = PLAYER_SPEED * scale_factor,
    x=x - width * scale/2,
    y=y - height * scale/2,
    last_shoot = 0,
    bang = bang,
  }
  
  local get_name = function()
    return self.name
  end
 
   local draw_life = function()
    y = self.y - 20 * scale_factor
    size = 10 * scale_factor
    x = self.x + self.width / 2 - (self.life * size) / 2

    for i=1, self.life do
      love.graphics.setColor(0, 1, 0)
      love.graphics.rectangle("fill", x, y, size, size)
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", x, y, size, size)
      x = x + size
    end
  end
 
  local draw = function()
    love.graphics.setColor(1, 1, 1)    
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale)
    draw_life()
  end
  
  local get_life = function()
    return self.life
  end
  
  local hit = function()
    if self.life > 0 then
      self.life = self.life - 1
    end
  end
  
  local touch_item = function(x, y, item)
    item_x, item_y, width, height = item.get_pos()
    return x + self.width > item_x and x < item_x + width and
           y + self.height > item_y and y < item_y + height
  end

  local touch = function(x, y)
    if touch_item(x, y, boss) then
      return true
    end
    for i, crossbow in ipairs(crossbows) do
      if touch_item(x, y, crossbow) then
        return true
      end
    end
  end

  local move_y = function (d)
    if (self.y + self.height < window_height or d < 0) and (self.y > 0 or d > 0) then
      next_y = self.y + self.speed * d
      if not touch(self.x, next_y) then
        self.y = next_y
      end
    end
  end
  
  local move_x = function (d)
    if (self.x + self.width < window_width or d < 0) and (self.x > 0 or d > 0) then
      next_x = self.x + self.speed * d
      if not touch(next_x, self.y) then
        self.x = next_x
      end
    end
  end
  
  local get_pos = function()
    return self.x, self.y, self.width, self.height
  end
  
  local get_center = function()
    return self.x + self.width / 2, self.y + self.height / 2
  end
  
  local shoot = function(x, y)
    if love.timer.getTime() - self.last_shoot > PLAYER_SHOOTING then
      self.last_shoot = love.timer.getTime()
      love.audio.play(self.bang:clone())
      direction = math.atan2((self.y + self.height/ 2 - y), (self.x + self.width / 2 - x))
      table.insert(bullets, newBullet(PLAYER_BULLET_SPEED, self.x + self.width / 2, self.y + self.height/ 2, direction, self.name))
    end
  end
    
  return {
    get_name = get_name,
    get_pos = get_pos,
    get_life = get_life,
    get_center = get_center,
    hit = hit,
    move_x = move_x ,
    move_y = move_y,
    draw = draw,
    shoot = shoot,
  }
end
