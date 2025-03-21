local GameState = require("src.game_state")
local Graphics = require("src.graphics")
local Pieces = require("src.pieces")

function love.load()
    GameState.reset()

    local font = love.graphics.newFont("assets/font.ttf", 32)
    love.graphics.setFont(font)
end

function love.update(dt)
    GameState.update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "up" then
        Pieces.rotate(1)
    elseif key == "z" then
        Pieces.rotate(-1)
    end
end

function love.draw()
    Graphics.draw_background()
    Graphics.draw_grid()
    Graphics.draw_current_piece()
    Graphics.draw_ui()
end
