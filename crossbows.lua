function newCrossbow(images, position, bang)
  local width, height = images[1]:getDimensions()
  local scale = 150 * scale_factor / width
  
  if position == 1 then
    x = margin
    y = margin
    rotation = 1.35
  elseif position == 2 then
    x = window_width - margin
    y = margin
    rotation = 3.55
  elseif position == 3 then
    x = window_width - margin
    y = window_height - margin
    rotation = 1.35 + math.pi
  elseif position == 4 then
    x = margin
    y = window_height - margin
    rotation = 3.55 + math.pi
  end
  
  local self = {
    name = "crossbow",
    images = images,
    image_width = width,
    image_height= height,
    width = width * scale,
    height = height * scale,
    scale = scale,
    x=x,
    y=y,
    rotation=rotation,
    status = 1,  -- 1=shooting 2=empty
    last_shoot = 0,
    bang = bang,
  }
  
  local get_name = function()
    return self.name
  end
  
  local draw = function()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.images[self.status], self.x, self.y, self.rotation, self.scale, self.scale, self.image_width/2, self.image_height/2)
  end

  local get_pos = function()
    return self.x - self.width/2, self.y - self.height/2, self.width, self.height
  end
  
  local get_life = function()
    return self.life
  end
  
  local reload = function()
    if self.status == 2 then
      if love.timer.getTime() - self.last_shoot > CROSSBOW_RELOAD then
        self.status = 1
      end
    end
  end
    
  local shoot = function(boss)
    if self.status == 1 then
      self.last_shoot = love.timer.getTime()
      self.status = 2
      x, y, width, height = boss.get_pos()
      direction = math.atan2((self.y - (y + height/ 2)), (self.x - (x + width / 2)))
      love.audio.play(self.bang:clone())
      table.insert(bullets, newBullet(CROSSBOW_BULLET_SPEED, self.x, self.y, direction, "crossbow", self.images[3], self.rotation + 0.7, self.scale))
    end
  end
  
  return {
    get_name = get_name,
    get_pos = get_pos,
    get_life = get_life,
    draw = draw,
    shoot = shoot,
    reload = reload,
  }
end