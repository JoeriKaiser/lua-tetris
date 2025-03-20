local Grid = require("src.grid")
local Pieces = require("src.pieces")
local Constants = require("src.constants")

local GameState = {
  game_over = false,
  fall_timer = 0,
  move_delay = 0.15,  -- Delay between moves
  move_timer = 0,     -- Timer for horizontal movement
  das_delay = 0.3,    -- Delayed Auto Shift initial delay
  das_timer = 0       -- Timer for DAS
}

function GameState.reset()
    Grid.create_empty()
    Grid.score = 0
    GameState.game_over = false
    GameState.fall_timer = 0
    Pieces.spawn_new()
end

function GameState.update(dt)
    if GameState.game_over then
        if love.keyboard.isDown("r") then
            GameState.reset()
        end
        return
    end

    GameState.fall_timer = GameState.fall_timer + dt
    if GameState.fall_timer >= Constants.FALL_SPEED then
        GameState.fall_timer = 0
        if not Grid.check_collision(Pieces.current, 0, 1) then
            Pieces.current.y = Pieces.current.y + 1
        else
            Grid.lock_piece(Pieces.current)
            Pieces.spawn_new()
            if Grid.check_collision(Pieces.current, 0, 0) then
                GameState.game_over = true
            end
        end
    end

    GameState.handle_input(dt)
end

function GameState.handle_input(dt)
  GameState.move_timer = GameState.move_timer + dt

  if love.keyboard.isDown("left") then
      if GameState.move_timer >= GameState.move_delay then
          if not Grid.check_collision(Pieces.current, -1, 0) then
              Pieces.current.x = Pieces.current.x - 1
              GameState.move_timer = 0
          end
      end
  elseif love.keyboard.isDown("right") then
      if GameState.move_timer >= GameState.move_delay then
          if not Grid.check_collision(Pieces.current, 1, 0) then
              Pieces.current.x = Pieces.current.x + 1
              GameState.move_timer = 0
          end
      end
  end

  if love.keyboard.isDown("down") then
      if GameState.move_timer >= GameState.move_delay / 2 then
          if not Grid.check_collision(Pieces.current, 0, 1) then
              Pieces.current.y = Pieces.current.y + 1
              GameState.move_timer = 0
              GameState.fall_timer = 0
          end
      end
  end
end

return GameState
