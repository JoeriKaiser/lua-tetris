local Constants = require("src.constants")
local Grid = require("src.grid")

local Pieces = {
  current = nil,
  -- SRS wall kick data
  WALL_KICK_DATA = {
      -- For J, L, S, T, Z pieces
      [0] = {
          [1] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}},
          [3] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}
      },
      [1] = {
          [2] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}},
          [0] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}
      },
      [2] = {
          [3] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}},
          [1] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}
      },
      [3] = {
          [0] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}},
          [2] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}
      }
  },
  -- I piece has different wall kick data
  WALL_KICK_I = {
      [0] = {
          [1] = {{0, 0}, {-2, 0}, {1, 0}, {-2, -1}, {1, 2}},
          [3] = {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}}
      },
      [1] = {
          [2] = {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}},
          [0] = {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}}
      },
      [2] = {
          [3] = {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}},
          [1] = {{0, 0}, {1, 0}, {-2, 0}, {1, -2}, {-2, 1}}
      },
      [3] = {
          [0] = {{0, 0}, {1, 0}, {-2, 0}, {1, -2}, {-2, 1}},
          [2] = {{0, 0}, {-2, 0}, {1, 0}, {-2, -1}, {1, 2}}
      }
  }
}

Pieces.TETROMINOES = {
  { -- I
      { 0, 0, 0, 0 },
      { 1, 1, 1, 1 },
      { 0, 0, 0, 0 },
      { 0, 0, 0, 0 },
  },
  { -- O
      { 1, 1 },
      { 1, 1 },
  },
  { -- T
      { 0, 1, 0 },
      { 1, 1, 1 },
      { 0, 0, 0 },
  },
  { -- L
      { 1, 0, 0 },
      { 1, 1, 1 },
      { 0, 0, 0 },
  },
  { -- J
      { 0, 0, 1 },
      { 1, 1, 1 },
      { 0, 0, 0 },
  },
  { -- S
      { 0, 1, 1 },
      { 1, 1, 0 },
      { 0, 0, 0 },
  },
  { -- Z
      { 1, 1, 0 },
      { 0, 1, 1 },
      { 0, 0, 0 },
  },
}

function Pieces.spawn_new()
  local shape_index = love.math.random(#Pieces.TETROMINOES)
  Pieces.current = {
      shape = Pieces.TETROMINOES[shape_index],
      shape_index = shape_index,
      x = math.floor(Constants.GRID_WIDTH / 2) - 1,
      y = 1,
  }
  return Pieces.current
end

function Pieces.rotate(direction)
  local old_rotation = Pieces.current.rotation or 0
  local new_rotation = (old_rotation + direction) % 4

  local old_shape = Pieces.current.shape
  Pieces.current.shape = Pieces.rotate_matrix(old_shape, direction > 0)

  local kick_data
  if Pieces.current.shape_index == 1 then -- I piece
      kick_data = Pieces.WALL_KICK_I[old_rotation][new_rotation]
  else
      kick_data = Pieces.WALL_KICK_DATA[old_rotation][new_rotation]
  end

  for _, offset in ipairs(kick_data) do
      if not Grid.check_collision(Pieces.current, offset[1], offset[2]) then
          Pieces.current.x = Pieces.current.x + offset[1]
          Pieces.current.y = Pieces.current.y + offset[2]
          Pieces.current.rotation = new_rotation
          return true
      end
  end

  Pieces.current.shape = old_shape
  return false
end

function Pieces.rotate_matrix(matrix, clockwise)
  local new_matrix = {}
  local n = #matrix
  for y = 1, n do
      new_matrix[y] = {}
      for x = 1, n do
          if clockwise then
              new_matrix[y][x] = matrix[n - x + 1][y]
          else
              new_matrix[y][x] = matrix[x][n - y + 1]
          end
      end
  end
  return new_matrix
end

return Pieces
