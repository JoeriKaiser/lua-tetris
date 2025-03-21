local Grid = require("src.grid")
local Pieces = require("src.pieces")
local Constants = require("src.constants")

local GameState = {
    -- Game state
    game_over = false,
    paused = false,
    level = 1,

    FALL_SPEEDS = {
        1.0,    -- Level 1
        0.85,   -- Level 2
        0.7,    -- Level 3
        0.55,   -- Level 4
        0.4,    -- Level 5
        0.3,    -- Level 6
        0.25,   -- Level 7
        0.2,    -- Level 8
        0.15,   -- Level 9
        0.1     -- Level 10
    },

    DAS_INITIAL_DELAY = 0.17,  -- Delayed Auto Shift initial delay
    DAS_REPEAT_DELAY = 0.03,   -- Delay between repeated moves after initial delay
    SOFT_DROP_DELAY = 0.05,    -- Delay for soft drop
    LOCK_DELAY = 0.5,          -- Time piece has to lock after touching ground

    fall_timer = 0,
    lock_timer = 0,
    das_timer = 0,
    last_move_direction = 0,   -- -1 for left, 1 for right, 0 for none
    soft_drop_timer = 0
}

function GameState.reset()
    Grid.create_empty()
    Grid.score = 0
    GameState.game_over = false
    GameState.paused = false
    GameState.level = 1
    GameState.reset_timers()
    Pieces.spawn_new()
end

function GameState.reset_timers()
    GameState.fall_timer = 0
    GameState.lock_timer = 0
    GameState.das_timer = 0
    GameState.last_move_direction = 0
    GameState.soft_drop_timer = 0
end

function GameState.get_fall_speed()
    return GameState.FALL_SPEEDS[math.min(GameState.level, #GameState.FALL_SPEEDS)]
end

function GameState.update(dt)
    if GameState.game_over then
        if love.keyboard.isDown("r") then
            GameState.reset()
        end
        return
    end

    if GameState.paused then
        if love.keyboard.isDown("p") then
            GameState.paused = false
        end
        return
    end

    GameState.handle_piece_falling(dt)
    GameState.handle_input(dt)
    GameState.update_level()
end

function GameState.handle_piece_falling(dt)
    local on_ground = Grid.check_collision(Pieces.current, 0, 1)

    if on_ground then
        GameState.lock_timer = GameState.lock_timer + dt
        if GameState.lock_timer >= GameState.LOCK_DELAY then
            GameState.lock_current_piece()
        end
    else
        GameState.lock_timer = 0
        GameState.fall_timer = GameState.fall_timer + dt
        if GameState.fall_timer >= GameState.get_fall_speed() then
            GameState.fall_timer = 0
            Pieces.current.y = Pieces.current.y + 1
        end
    end
end

function GameState.lock_current_piece()
    Grid.lock_piece(Pieces.current)
    Pieces.spawn_new()
    GameState.reset_timers()

    if Grid.check_collision(Pieces.current, 0, 0) then
        GameState.game_over = true
    end
end

function GameState.handle_input(dt)
    local move_direction = 0
    if love.keyboard.isDown("left") then move_direction = -1
    elseif love.keyboard.isDown("right") then move_direction = 1 end

    if move_direction ~= 0 then
        if move_direction ~= GameState.last_move_direction then
            -- Initial move
            if not Grid.check_collision(Pieces.current, move_direction, 0) then
                Pieces.current.x = Pieces.current.x + move_direction
                GameState.das_timer = 0
            end
        else
            GameState.das_timer = GameState.das_timer + dt
            if GameState.das_timer >= GameState.DAS_INITIAL_DELAY then
                if not Grid.check_collision(Pieces.current, move_direction, 0) then
                    Pieces.current.x = Pieces.current.x + move_direction
                    GameState.das_timer = GameState.das_timer - GameState.DAS_REPEAT_DELAY
                end
            end
        end
    end
    GameState.last_move_direction = move_direction

    if love.keyboard.isDown("down") then
        GameState.soft_drop_timer = GameState.soft_drop_timer + dt
        if GameState.soft_drop_timer >= GameState.SOFT_DROP_DELAY then
            if not Grid.check_collision(Pieces.current, 0, 1) then
                Pieces.current.y = Pieces.current.y + 1
                GameState.soft_drop_timer = 0
                GameState.fall_timer = 0
                Grid.score = Grid.score + 1  -- Bonus points for soft drop
            end
        end
    else
        GameState.soft_drop_timer = 0
    end
end

function GameState.update_level()
    GameState.level = math.floor(Grid.score / 1000) + 1
    GameState.level = math.min(GameState.level, #GameState.FALL_SPEEDS)
end

return GameState