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
    for y = Constants.GRID_HEIGHT, 1, -1 do
        local complete = true
        for x = 1, Constants.GRID_WIDTH do
            if Grid.cells[y][x] == 0 then
                complete = false
                break
            end
        end

        if complete then
            table.remove(Grid.cells, y)
            table.insert(Grid.cells, 1, {})
            for x = 1, Constants.GRID_WIDTH do
                Grid.cells[1][x] = 0
            end
            Grid.score = Grid.score + 100
        end
    end
end

return Grid
