local Constants = require("src.constants")
local Grid = require("src.grid")
local Pieces = require("src.pieces")
local GameState = require("src.game_state")

local Graphics = {}

local function get_grid_offset()
  local total_width = Constants.GRID_WIDTH * Constants.BLOCK_SIZE
  local total_height = Constants.GRID_HEIGHT * Constants.BLOCK_SIZE
  local offset_x = (love.graphics.getWidth() - total_width) / 2
  local offset_y = (love.graphics.getHeight() - total_height) / 2
  return offset_x, offset_y
end

function Graphics.draw_background()
    love.graphics.setColor(0.1, 0.1, 0.2, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(0.15, 0.15, 0.25, 0.3)
    local size = 20
    for x = 0, love.graphics.getWidth(), size do
        love.graphics.line(x, 0, x, love.graphics.getHeight())
    end
    for y = 0, love.graphics.getHeight(), size do
        love.graphics.line(0, y, love.graphics.getWidth(), y)
    end
end

function Graphics.draw_block(x, y, color)
    local block_size = Constants.BLOCK_SIZE

    love.graphics.setColor(color[1], color[2], color[3], 0.9)
    love.graphics.rectangle("fill", x, y, block_size - 1, block_size - 1)

    love.graphics.setColor(color[1] + 0.2, color[2] + 0.2, color[3] + 0.2, 0.9)
    love.graphics.line(x, y, x + block_size - 1, y)
    love.graphics.line(x, y, x, y + block_size - 1)

    love.graphics.setColor(color[1] - 0.2, color[2] - 0.2, color[3] - 0.2, 0.9)
    love.graphics.line(x + block_size - 1, y, x + block_size - 1, y + block_size - 1)
    love.graphics.line(x, y + block_size - 1, x + block_size - 1, y + block_size - 1)
end

function Graphics.draw_grid()
    local offset_x, offset_y = get_grid_offset()

    love.graphics.setColor(0.3, 0.3, 0.4, 0.5)
    for y = 1, Constants.GRID_HEIGHT do
        for x = 1, Constants.GRID_WIDTH do
            love.graphics.rectangle("line",
                offset_x + (x - 1) * Constants.BLOCK_SIZE,
                offset_y + (y - 1) * Constants.BLOCK_SIZE,
                Constants.BLOCK_SIZE,
                Constants.BLOCK_SIZE)
        end
    end

    for y = 1, Constants.GRID_HEIGHT do
        for x = 1, Constants.GRID_WIDTH do
            if Grid.cells[y][x] > 0 then
                Graphics.draw_block(
                    offset_x + (x - 1) * Constants.BLOCK_SIZE,
                    offset_y + (y - 1) * Constants.BLOCK_SIZE,
                    Constants.PIECE_COLORS[Grid.cells[y][x]]
                )
            end
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function Graphics.draw_current_piece()
    if not GameState.game_over then
        local offset_x, offset_y = get_grid_offset()

        for y = 1, #Pieces.current.shape do
            for x = 1, #Pieces.current.shape[y] do
                if Pieces.current.shape[y][x] == 1 then
                    Graphics.draw_block(
                        offset_x + (Pieces.current.x + x - 2) * Constants.BLOCK_SIZE,
                        offset_y + (Pieces.current.y + y - 2) * Constants.BLOCK_SIZE,
                        Constants.PIECE_COLORS[Pieces.current.shape_index]
                    )
                end
            end
        end
    end
end

function Graphics.draw_ui()
    love.graphics.setColor(0.1, 0.1, 0.2, 0.8)
    love.graphics.rectangle("fill", 10, 10, 200, 50)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("SCORE", 20, 15)
    love.graphics.print(Grid.score, 20, 35)

    if GameState.game_over then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(1, 1, 1, 1)
        local msg = "GAME OVER"
        local msg2 = "Press R to restart"
        local font = love.graphics.getFont()
        local w1 = font:getWidth(msg)
        local w2 = font:getWidth(msg2)
        love.graphics.print(msg, love.graphics.getWidth()/2 - w1/2, love.graphics.getHeight()/2 - 20)
        love.graphics.print(msg2, love.graphics.getWidth()/2 - w2/2, love.graphics.getHeight()/2 + 20)
    end
end

function Graphics.draw_next_piece()
    local next_piece = Pieces.next
    if not next_piece then return end

    local window_width = love.graphics.getWidth()
    local preview_width = Constants.BLOCK_SIZE * 4
    local preview_x = window_width - preview_width - 40
    local preview_y = 50

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("NEXT", preview_x, preview_y - 40)

    for y = 1, #next_piece.shape do
        for x = 1, #next_piece.shape[y] do
            if next_piece.shape[y][x] == 1 then
                love.graphics.setColor(Constants.PIECE_COLORS[next_piece.shape_index])
                love.graphics.rectangle("fill",
                    preview_x + (x-1) * Constants.BLOCK_SIZE,
                    preview_y + (y-1) * Constants.BLOCK_SIZE,
                    Constants.BLOCK_SIZE - 1,
                    Constants.BLOCK_SIZE - 1)
            end
        end
    end
end

return Graphics
