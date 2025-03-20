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

function Graphics.draw_grid()
  local offset_x, offset_y = get_grid_offset()

  for y = 1, Constants.GRID_HEIGHT do
      for x = 1, Constants.GRID_WIDTH do
          love.graphics.rectangle("line",
              offset_x + (x - 1) * Constants.BLOCK_SIZE,
              offset_y + (y - 1) * Constants.BLOCK_SIZE,
              Constants.BLOCK_SIZE,
              Constants.BLOCK_SIZE)

          if Grid.cells[y][x] > 0 then
              love.graphics.setColor(Constants.PIECE_COLORS[Grid.cells[y][x]])
              love.graphics.rectangle("fill",
                  offset_x + (x - 1) * Constants.BLOCK_SIZE,
                  offset_y + (y - 1) * Constants.BLOCK_SIZE,
                  Constants.BLOCK_SIZE - 1,
                  Constants.BLOCK_SIZE - 1)
              love.graphics.setColor(1, 1, 1)
          end
      end
  end
end

function Graphics.draw_current_piece()
  if not GameState.game_over then
      local offset_x, offset_y = get_grid_offset()

      love.graphics.setColor(Constants.PIECE_COLORS[Pieces.current.shape_index])
      for y = 1, #Pieces.current.shape do
          for x = 1, #Pieces.current.shape[y] do
              if Pieces.current.shape[y][x] == 1 then
                  love.graphics.rectangle("fill",
                      offset_x + (Pieces.current.x + x - 2) * Constants.BLOCK_SIZE,
                      offset_y + (Pieces.current.y + y - 2) * Constants.BLOCK_SIZE,
                      Constants.BLOCK_SIZE - 1,
                      Constants.BLOCK_SIZE - 1)
              end
          end
      end
      love.graphics.setColor(1, 1, 1)
  end
end

function Graphics.draw_ui()
    love.graphics.print("Score: " .. Grid.score, 10, 10)
    if GameState.game_over then
        love.graphics.print(
            "Game Over! Press R to restart",
            love.graphics.getWidth() / 2 - 100,
            love.graphics.getHeight() / 2
        )
    end
end

return Graphics
