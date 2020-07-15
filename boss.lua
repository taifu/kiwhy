function newBoss(images, x, y, bang)
  local width, height = images[1]:getDimensions()
  local scale = 150 * scale_factor / width
  
  local self = {
    name = "boss",
    life = BOSS_LIFE,
    status = 1, -- > 1-4 -> invulnerable 5 -> vulnerable
    images = images,
    width = width * scale,
    height = height * scale,
    scale = scale,
    x=x - width * scale/2,
    y=y - height * scale/2,
    rebuild_armor = 0,
    last_shoot = love.timer.getTime() + 2,
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
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("fill", x, y, size, size)
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle("line", x, y, size, size)
      x = x + size
    end
  end
  
  local draw = function()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.images[self.status], self.x, self.y, 0, self.scale)
    draw_life()
  end

  local get_pos = function()
    return self.x, self.y, self.width, self.height
  end
  
  local get_life = function()
    return self.life
  end
  
  local armor = function()
    if self.status == 5 then
      if love.timer.getTime() - self.rebuild_armor > BOSS_REBUILD_ARMOR then
        self.status = 1
      end
    end
  end
  
  local hit = function()
    if self.status == 5 then
      if self.life > 0 then
        self.life = self.life - 1
      end
    end
  end
  
  local arrow = function()
    if self.status < 5 then
      self.status = self.status + 1
      if self.status == 5 then
        self.rebuild_armor = love.timer.getTime()
      end
    else
      hit()
    end
  end

  local shoot = function(x, y)
    if love.timer.getTime() - self.last_shoot > BOSS_SHOOTING then
      self.last_shoot = love.timer.getTime()
      love.audio.play(self.bang:clone())  
      direction = math.atan2((self.y + self.height/ 2 - y), (self.x + self.width / 2 - x))
      table.insert(bullets, newBullet(BOSS_BULLET_SPEED, self.x + self.width / 2, self.y + self.height/ 2, direction, self.name))
    end                   
  end
  
  return {
    get_name = get_name,
    get_pos = get_pos,
    get_life = get_life,
    draw = draw,
    hit = hit,
    arrow = arrow,
    armor = armor,
    shoot = shoot,
  }
end
