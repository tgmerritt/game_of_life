require_relative "world"
require_relative "cell"

class Game
  attr_accessor :world, :seeds

  # requires 1 World object and an Array of 1 or more seeds (more makes more sense)
  def initialize(world, seeds)
    @world = world
    @seeds = seeds

    seeds.each do |s|
      world.grid[s[0]][s[1]].alive = true
    end
  end

  def evolve!
    next_round_live = []
    next_round_dead = []

    world.cells.each do |cell|
      if cell.alive? && world.living_neighbors_for(cell).count < 2
        next_round_dead << cell
      end
      if cell.alive? && ([2, 3].include? world.living_neighbors_for(cell).count)
        next_round_live << cell
      end
      if cell.alive? && world.living_neighbors_for(cell).count > 3
        next_round_dead << cell
      end
      if cell.dead? && world.living_neighbors_for(cell).count == 3
        next_round_live << cell
      end
    end

    next_round_live.each do |cell|
      cell.revive!
    end
    next_round_dead.each do |cell|
      cell.die!
    end
  end
end
