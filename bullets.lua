function newBullet(speed, x, y, direction, shooter, image, rotation, scale)
  local self = {
    x=x,
    y=y,
    shooter=shooter,
    width=6 * scale_factor,
    height=6 * scale_factor,
    speed = speed * scale_factor,
    direction=direction,
    image=image,
    rotation=rotation,
    scale=scale,
  }
  local draw = function()
    if self.image then
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale, self.image:getWidth() * self.scale / 2, self.image:getHeight() * self.scale / 2)
    else
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle('fill', self.x - self.width/2, self.y - self.height/2, self.width, self.height)
    end
  end
  
  local get_shooter = function()
    return self.shooter
  end
    
  local direct_to = function(player)
    player_x, player_y = player.get_center()
    self.direction = math.atan2((self.y + self.height/ 2 - player_y), (self.x + self.width / 2 - player_x))
  end

  local move = function(dt)
    self.x = self.x - self.speed * dt * math.cos(self.direction)
    self.y = self.y - self.speed * dt * math.sin(self.direction)
  end
  
  local outside = function()
    return self.x < 0 or self.y < 0 or self.x > window_width or self.y > window_height
  end
      
  local get_pos = function()
    return self.x, self.y, self.width, self.height
  end
 
  local hit = function(item)
    x, y, width, height = item.get_pos()
    if item.get_name() ~= self.shooter then
      return x < self.x - self.width/2 and x + width > self.x + self.width/2 and
           y < self.y - self.height/2 and y + height > self.y + self.height/2
    end
  end

  return {
    outside = outside,
    get_shooter = get_shooter,
    get_pos = get_pos,
    move = move,
    draw = draw,
    direct_to = direct_to,
    hit = hit,
  }
end
