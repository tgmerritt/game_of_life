class World
  attr_accessor :rows, :cols, :grid, :cells

  def initialize(rows = 3, cols = 3)
    @rows = rows
    @cols = cols
    @cells = []
    @grid = Array.new(rows) do |row|
      Array.new(cols) do |col|
        cell = Cell.new(col, row)
        cells << cell
        cell
      end
    end
  end

  def living_neighbors_for(cell)
    living_neighbors = []
    # North
    if cell.y > 0
      candidate = grid[cell.y - 1][cell.x]
      living_neighbors << candidate if candidate.alive?
    end
    # South
    if cell.y < (rows - 1)
      candidate = grid[cell.y + 1][cell.x]
      living_neighbors << candidate if candidate.alive?
    end
    # East
    if cell.x < (cols - 1)
      candidate = grid[cell.y][cell.x + 1]
      living_neighbors << candidate if candidate.alive?
    end
    # West
    if cell.x > 0
      candidate = grid[cell.y][cell.x - 1]
      living_neighbors << candidate if candidate.alive?
    end
    # North East
    if cell.y > 0 && cell.x < (cols - 1)
      candidate = grid[cell.y - 1][cell.x + 1]
      living_neighbors << candidate if candidate.alive?
    end
    # North West
    if cell.y > 0 && cell.x > 0
      candidate = grid[cell.y - 1][cell.x - 1]
      living_neighbors << candidate if candidate.alive?
    end
    # South East
    if cell.y < (rows - 1) && cell.x < (cols - 1)
      candidate = grid[cell.y + 1][cell.x + 1]
      living_neighbors << candidate if candidate.alive?
    end
    # South West
    if cell.y < (rows - 1) && cell.x > 0
      candidate = grid[cell.y + 1][cell.x - 1]
      living_neighbors << candidate if candidate.alive?
    end

    living_neighbors
  end
end
