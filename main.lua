-- Configuration 
FULLSCREEN = true
-- Bullet speeds
PLAYER_BULLET_SPEED = 500
CROSSBOW_BULLET_SPEED = 500
FRUIT_BULLET_SPEED = 500
BOSS_BULLET_SPEED = 700
-- Lifes
BOSS_LIFE = 20
PLAYER_LIFE = 10
-- Fruits
FRUIT_RATES = {0.4, 0.05, 0.55} -- sum must be 1
-- Timeout in seconds
MAYHEM_DELAY = 2
PLAYER_SHOOTING = 0.225
CROSSBOW_RELOAD = 7
BOSS_SHOOTING = 0.4
BOSS_REBUILD_ARMOR = 3 -- seconds
FRUIT_SHOOTING = 1
FRUIT_SPAWN_MIN = 0.4
FRUIT_SPAWN_MAX = 0.8
SPLAT_REMOVE = 99999
-- Misc
PLAYER_SPEED = 300

require 'crossbows'
require 'bullets'
require 'boss'
require 'player'
require 'fruits'
  
function love.load()
  love.window.setMode(1280, 720, {fullscreen=FULLSCREEN})
  love.window.setTitle("Kiwhy")
  iconData = love.image.newImageData("images/Frutta/Anguria_0.png")
  --icon = love.graphics.newImage("")
  --print(icon)
  love.window.setIcon(iconData)
  window_width, window_height = love.graphics.getDimensions()
    
  -- Scale factor
  scale_factor = window_width / 1600
  
  -- Main images
  gamespace_image = love.graphics.newImage("images/MainGameSpace.jpg")
  gamespace_width, gamespace_height = gamespace_image:getDimensions()
  gamespace_scale_x = window_width / gamespace_width
  gamespace_scale_y = window_height / gamespace_height
  main_menu_image = love.graphics.newImage("images/Menu/Menu_Final_Audio.png") 
  main_menu_image_no_audio = love.graphics.newImage("images/Menu/Menu_Final_NoAudio.png")
  main_menu_width, main_menu_height = main_menu_image:getDimensions()
  main_menu_scale_x = window_width / main_menu_width
  main_menu_scale_y = window_height / main_menu_height
  main_menu_theme = love.audio.newSource("audio/Menu_Song.mp3", "static")
  credits_image = love.graphics.newImage("images/Menu/Menu_Credits.png") 
  credits_width, credits_height = credits_image:getDimensions()
  credits_scale_x = window_width / credits_width
  credits_scale_y = window_height / credits_height
  narrative_image = love.graphics.newImage("images/Menu/Menu_Narrative.png") 
  narrative_width, narrative_height = credits_image:getDimensions()
  narrative_scale_x = window_width / narrative_width
  narrative_scale_y = window_height / narrative_height
  controls_image = love.graphics.newImage("images/Menu/Menu_Controls.png") 
  controls_width, controls_height = controls_image:getDimensions()
  controls_scale_x = window_width / controls_width
  controls_scale_y = window_height / controls_height
  popup_gameover = love.graphics.newImage("images/Menu/PopUp_GameOver.png") 
  popup_youwin = love.graphics.newImage("images/Menu/PopUp_YouWin.png")
  game_win_width, game_win_height = popup_gameover:getDimensions()
  popup_scale_x = 1200 * scale_factor / game_win_width
  popup_scale_y = 700 * scale_factor / game_win_height
  back_button = love.graphics.newImage("images/Menu/Back.png")
  back_button_width, back_button_height = back_button:getDimensions()
  back_button_scale_x = 370 * scale_factor / back_button_width
  back_button_scale_y = 130 * scale_factor / back_button_height

  -- Misc
  game_audio = true
  margin = 100 * scale_factor
  time_font = love.graphics.newFont("Wilkey.ttf", 60)
  
  -- Mouse
  love.mouse.setVisible(false) -- make default mouse invisible
  mouse_image = love.graphics.newImage("images/Mouse/mouse2.png") -- load in a custom mouse image
  mouse_width, mouse_height = mouse_image:getDimensions()
  mouse_scale = scale_factor
  mouse_dx = (mouse_width * mouse_scale) / 2 -- center mouse img
  mouse_dy = (mouse_height * mouse_scale) / 2 -- center mouse img
  
  -- Boss
  boss_images = {
    love.graphics.newImage("images/Frutta/Anguria_1.png"),
    love.graphics.newImage("images/Frutta/Anguria_3 Danno corazza 1_4.png"),
    love.graphics.newImage("images/Frutta/Anguria_4 Danno corazza 2_4.png"),
    love.graphics.newImage("images/Frutta/Anguria_5 Danno corazza 3_4.png"),
    love.graphics.newImage("images/Frutta/Anguria_6 Vulnerabile.png"),
    love.graphics.newImage("images/Frutta/Anguria_2_Sparo.png"),
  }
  
  boss_shoot =  love.audio.newSource("audio/Sparo_Boss.wav", "static")
  boss_shoot:setVolume(0.2)
  
  -- Crossbow
  crossbows_images = {
    love.graphics.newImage("images/Frutta/Balestra_SI_Freccia.png"),
    love.graphics.newImage("images/Frutta/Balestra_NO_Freccia.png"),
    love.graphics.newImage("images/Frutta/Freccia.png"),
  }
  crossbow_audio = love.audio.newSource("audio/Balestra.wav", "static");
  crossbows = {
    newCrossbow(crossbows_images, 1, crossbow_audio),
    newCrossbow(crossbows_images, 2, crossbow_audio),
    newCrossbow(crossbows_images, 3, crossbow_audio),
    newCrossbow(crossbows_images, 4, crossbow_audio),
  }
  
  -- Fruits
  all_fruit_images = {{{
        love.graphics.newImage("images/Frutta/Melone_VitaAlta.png"),
        love.graphics.newImage("images/Frutta/Melone_VitaMedia.png"),
        love.graphics.newImage("images/Frutta/Melone_VitaBassa.png"),
        love.graphics.newImage("images/Frutta/Splat Melone.png"),
      }
    },
    {
      {
        love.graphics.newImage("images/Frutta/Durian.png"),
        love.graphics.newImage("images/Frutta/Durian.png"),
        love.graphics.newImage("images/Frutta/Durian.png"),
        love.graphics.newImage("images/Frutta/Splat Durian.png"),
      }
    },
    {
      {
        love.graphics.newImage("images/Frutta/Arancia_VitaAlta.png"),
        love.graphics.newImage("images/Frutta/Arancia_VitaMedia.png"),
        love.graphics.newImage("images/Frutta/Arancia_VitaBassa.png"),
        love.graphics.newImage("images/Frutta/Splat Arancia.png"),
      },
      {
        love.graphics.newImage("images/Frutta/More_VitaAlta.png"),
        love.graphics.newImage("images/Frutta/More_VitaMedia.png"),
        love.graphics.newImage("images/Frutta/More_VitaBassa.png"),
        love.graphics.newImage("images/Frutta/Splat More.png"),
      },
      {
        love.graphics.newImage("images/Frutta/Limone_VitaAlta.png"),
        love.graphics.newImage("images/Frutta/Limone_VitaMedia.png"),
        love.graphics.newImage("images/Frutta/Limone_VitaBassa.png"),
        love.graphics.newImage("images/Frutta/Splat Limone.png"),
      },
    }
  }
  all_fruit_audio = {love.audio.newSource("audio/Sparo_Boss.wav", "static"),
                     love.audio.newSource("audio/Spawn_Frutta.wav", "static"),
                     love.audio.newSource("audio/Cartoon_Splat.wav", "static")}
  
  -- Misc
  boss_theme = love.audio.newSource("audio/Boss_Fight_Theme.wav", "static")
  boss_theme:setVolume(0.2)
  game_win = love.audio.newSource("audio/Win.wav", "static")
  game_lost = love.audio.newSource("audio/Game_Over.flac", "static")
  
  player_image = love.graphics.newImage("images/Frutta/Kawai_De_Kiwi.png")
  player_audio = love.audio.newSource("audio/Sparo_Player.wav", "static")
    
  game_reset()
end

function game_reset()
  -- Boss
  boss = newBoss(boss_images, window_width / 2, window_height / 2, boss_shoot)
    
  -- Player
  player = newPlayer(player_image, window_width / 2, window_height - margin, player_audio)

  -- Menù
  game_status = 0 -- 0:menù 1:credits 2:play 3:game lost 4:game win 5:narrative 6:controls
  love.audio.stop()
  love.audio.play(main_menu_theme)
 
  bullets = {}
  fruits = {}
  
  mouse_pressed = false
  mouse_released = false 
  mouse_button = 0
  mouse_x = 0
  mouse_y = 0
  
end

function love.mousereleased( x, y, button )
  mouse_released = true
  mouse_x = x
  mouse_y = y
end

function love.mousepressed( x, y, button, istouch, presses )
  mouse_pressed = true
  mouse_x = x
  mouse_y = y
end

function love.update(dt)
  cursor_mouse_x, cursor_mouse_y = love.mouse.getPosition() 

  if game_status == 0 then
    if mouse_released then
      --main_menu_scale_x
      --main_menu_scale_y
      if mouse_x > 440 * main_menu_scale_x and mouse_x < 780 * main_menu_scale_x 
          and mouse_y > 765 * main_menu_scale_y and mouse_y < 870 * main_menu_scale_y then
        game_status = 5
      elseif mouse_x > 885 * main_menu_scale_x and mouse_x < 1050 * main_menu_scale_x 
          and mouse_y > 740 * main_menu_scale_y and mouse_y < 900 * main_menu_scale_y then
        game_audio = not game_audio
        if game_audio then
          love.audio.setVolume(1)
        else
          love.audio.setVolume(0)
        end
      elseif mouse_x > 1125 * main_menu_scale_x and mouse_x < 1500 * main_menu_scale_x 
          and mouse_y > 765 * main_menu_scale_y and mouse_y < 885 * main_menu_scale_y then
        game_status = 1
      elseif mouse_x > 780 * main_menu_scale_x and mouse_x < 1140 * main_menu_scale_x 
          and mouse_y > 940 * main_menu_scale_y and mouse_y < 1050 * main_menu_scale_y then
        love.event.quit(0)
      end
    end
  elseif game_status == 1 then
    if mouse_released then
      if mouse_x < 300 * main_menu_scale_x and mouse_y < 200 * main_menu_scale_y then
        game_status = 0
      end
    end
  elseif game_status == 5 then
    if mouse_released then
      if mouse_x > 845 * main_menu_scale_x and mouse_x < 1065 * main_menu_scale_x 
          and mouse_y > 910 * main_menu_scale_y and mouse_y < 1030 * main_menu_scale_y then
        game_status = 6
      end
    end
  elseif game_status == 6 then
    if mouse_released then
      if mouse_x > 845 * main_menu_scale_x and mouse_x < 1065 * main_menu_scale_x 
          and mouse_y > 910 * main_menu_scale_y and mouse_y < 1030 * main_menu_scale_y then
        game_status = 2
        love.audio.stop(main_menu_theme)
        love.audio.play(boss_theme)
        game_start_timer = love.timer.getTime()
        next_spawn_fruit = love.timer.getTime() + MAYHEM_DELAY
        boss.set_last_shoot(love.timer.getTime() + MAYHEM_DELAY)
      end
    end
  elseif game_status == 3 or game_status == 4 then
    if mouse_released then
      if mouse_x > 100 * back_button_scale_x and mouse_x < 450 * back_button_scale_x
          and mouse_y > 710 * back_button_scale_y and mouse_y < 810 * back_button_scale_y then
        game_reset()
      end
    end
  elseif game_status == 2 then
    -- Player
    if love.keyboard.isDown("w") then
      player.move_y(-dt)
    elseif love.keyboard.isDown("s") then
      player.move_y(dt)
    end
    if love.keyboard.isDown("a") then
      player.move_x(-dt)
    elseif love.keyboard.isDown("d") then
      player.move_x(dt)
    end
    
    if love.mouse.isDown(1) then
      player.shoot(cursor_mouse_x, cursor_mouse_y)
    end
    
    player_x, player_y = player.get_center()
    boss.shoot(player_x, player_y)
    
    if love.timer.getTime() > next_spawn_fruit then
      next_spawn_fruit = love.timer.getTime() + love.math.random(FRUIT_SPAWN_MIN, FRUIT_SPAWN_MAX)
      next_fruit_type = love.math.random()
      fruit_rate_cum = 0
      for fruit_type, fruit_rate in pairs(FRUIT_RATES) do
        fruit_rate_cum = fruit_rate_cum + fruit_rate
        if fruit_rate_cum >= next_fruit_type then
          table.insert(fruits, newFruit(all_fruit_images, all_fruit_audio, fruit_type))
          break
        end
      end
    end
    
    for i = #bullets, 1, -1 do
      bullet = bullets[i]
      bullet.move(dt)
      
      if bullet.outside() then
        table.remove(bullets, i)
      elseif bullet.hit(boss) then
        if bullet.get_shooter() == "crossbow" then
          boss.arrow()
          table.remove(bullets, i)
        elseif bullet.get_shooter() == "player" then
          boss.hit()
          table.remove(bullets, i)
        end
      elseif bullet.hit(player) then
        table.remove(bullets, i)
        player.hit()
      else
        if bullet.get_shooter() == "player" then
          for j, crossbow in ipairs(crossbows) do
            if bullet.hit(crossbow) then
              table.remove(bullets, i)
              crossbow.shoot(boss, fruits)
              break
            end
          end
        end
        for j, fruit in ipairs(fruits) do
          if bullet.hit(fruit) and not fruit.is_dead() then
            if bullet.get_shooter() == "crossbow" then
              fruit.dead()
            elseif bullet.get_shooter() == "fruit" then
              fruit.hit()
            elseif bullet.get_shooter() == "player" then
              fruit.hit()
              table.remove(bullets, i)
            elseif bullet.get_shooter() == "boss" then
              if fruit.get_type() == 1 then
                bullet.direct_to(player)
              end
            end
          end
        end
      end
    end
    
    for i = #fruits, 1, -1 do
      fruit = fruits[i]
      if fruit.remove() then
        table.remove(fruits, i)
      elseif fruit.get_type() == 2 then
        fruit.shoot(player_x, player_y)
      end
    end
          
    boss.armor()
    for j, crossbow in ipairs(crossbows) do
      crossbow.reload()
    end
    
    local source
    if boss.get_life() == 0 then
      game_status = 4
      source = game_win
      game_time_score = love.timer.getTime() - game_start_timer
    elseif player.get_life() == 0 then
      game_status = 3
      source = game_lost
      game_time_score = nil
    end
    if source then
      love.audio.stop(boss_theme)
      love.audio.play(source)
    end
  end
  
  mouse_released = false
  mouse_pressed = false
end

function love.draw()
  love.graphics.setColor(1, 1, 1)
  
  if game_status == 0 then
    local source
    if game_audio then
      source = main_menu_image
    else
      source = main_menu_image_no_audio
    end
    love.graphics.draw(source, 0, 0, 0, main_menu_scale_x, main_menu_scale_y)
    
  elseif game_status == 1 then
    love.graphics.draw(credits_image, 0, 0, 0, credits_scale_x, credits_scale_y)
    
  elseif game_status == 5 then
    love.graphics.draw(narrative_image, 0, 0, 0, narrative_scale_x, narrative_scale_y)
  
  elseif game_status == 6 then
    love.graphics.draw(controls_image, 0, 0, 0, controls_scale_x, controls_scale_y)

  elseif game_status >= 2 and game_status <= 4 then
    love.graphics.draw(gamespace_image, 0, 0, 0, gamespace_scale_x, gamespace_scale_y)
      
    for i, fruit in ipairs(fruits) do
      fruit.draw()
    end
    
    for i, crossbow in ipairs(crossbows) do
      crossbow.draw()
    end

    for i, bullet in ipairs(bullets) do
      bullet.draw()
    end
    
    boss.draw()
    
    player.draw()
    
    local popup
    if game_status == 3 then
      popup = popup_gameover
    elseif game_status == 4 then
      popup = popup_youwin
    end
    
    if popup then
      love.graphics.setColor(1, 1, 1)
      local popup_x = window_width / 2 - game_win_width * popup_scale_x / 2
      local popup_y = window_height / 2 - game_win_height * popup_scale_y / 2
      love.graphics.draw(popup, popup_x, popup_y, 0, popup_scale_x, popup_scale_y)
      love.graphics.draw(back_button, 100 * back_button_scale_x, window_height - 200 * back_button_scale_y, 0, back_button_scale_x, back_button_scale_y)
      if game_time_score then
        love.graphics.setFont(time_font)
        love.graphics.setColor(1/255*226,1/255*103,1/255*118)
        love.graphics.printf("You took " .. string.format("%.2f", game_time_score) .. " seconds", popup_x, popup_y, game_win_width * popup_scale_x , "center")
      end
    end
  end

  love.graphics.setColor(0, 0, 0)
  love.graphics.draw(mouse_image, cursor_mouse_x - mouse_dx, cursor_mouse_y - mouse_dx, 0, mouse_scale) -- draw the custom mouse image
end