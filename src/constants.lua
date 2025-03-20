local Constants = {
  BLOCK_SIZE = 30,
  GRID_WIDTH = 10,
  GRID_HEIGHT = 20,
  FALL_SPEED = 0.5,

  PIECE_COLORS = {
    { 0, 1, 1 },    -- I piece (Cyan)
    { 1, 1, 0 },    -- O piece (Yellow)
    { 1, 0, 1 },    -- T piece (Magenta)
    { 1, 0.5, 0 },  -- L piece (Orange)
    { 0, 0, 1 },    -- J piece (Blue)
    { 0, 1, 0 },    -- S piece (Green)
    { 1, 0, 0 },    -- Z piece (Red)
  }
}

return Constants
