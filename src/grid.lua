local Constants = require("src.constants")

local Grid = {
    cells = {},
    score = 0
}

function Grid.create_empty()
    Grid.cells = {}
    for y = 1, Constants.GRID_HEIGHT do
        Grid.cells[y] = {}
        for x = 1, Constants.GRID_WIDTH do
            Grid.cells[y][x] = 0
        end
    end
end

function Grid.check_collision(piece, offset_x, offset_y)
    for y = 1, #piece.shape do
        for x = 1, #piece.shape[y] do
            if piece.shape[y][x] == 1 then
                local next_x = piece.x + x + offset_x - 1
                local next_y = piece.y + y + offset_y - 1

                if next_x < 1 or 
                   next_x > Constants.GRID_WIDTH or 
                   next_y > Constants.GRID_HEIGHT or 
                   (next_y > 0 and Grid.cells[next_y][next_x] > 0) then
                    return true
                end
            end
        end
    end
    return false
end

function Grid.lock_piece(piece)
  for y = 1, #piece.shape do
      for x = 1, #piece.shape[y] do
          if piece.shape[y][x] == 1 then
              local grid_y = piece.y + y - 1
              if grid_y > 0 then
                  Grid.cells[grid_y][piece.x + x - 1] = piece.shape_index
              end
          end
      end
  end

  Grid.clear_lines()
end

function Grid.clear_lines()
    local lines_to_clear = {}
    for y = Constants.GRID_HEIGHT, 1, -1 do
        local complete = true
        for x = 1, Constants.GRID_WIDTH do
            if Grid.cells[y][x] == 0 then
                complete = false
                break
            end
        end
        if complete then
            table.insert(lines_to_clear, y)
        end
    end

    for _, y in ipairs(lines_to_clear) do
        table.remove(Grid.cells, y)
    end

    for i = 1, #lines_to_clear do
        local new_row = {}
        for x = 1, Constants.GRID_WIDTH do
            new_row[x] = 0
        end
        table.insert(Grid.cells, 1, new_row)
    end

    Grid.score = Grid.score + (#lines_to_clear * 100)
end

return Grid
