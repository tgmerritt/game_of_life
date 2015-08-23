require_relative "../../lib/cgol"
require_relative "../../lib/world"
require_relative "../../lib/cell"
require_relative "../../lib/game"

describe "CGOL" do
  let(:world) { World.new }
  let(:cell) { Cell.new(1, 1)}

  context "World" do
    it "creates a new World" do
      expect(world.is_a?(World)).to be(true)
    end

    it "responds to methods for it's attributes" do
      expect(world).to respond_to(:rows)
      expect(world).to respond_to(:cols)
      expect(world).to respond_to(:grid)
      expect(world).to respond_to(:cells)
    end

    it "adds all cells to cells attribute" do
      expect(world.cells.count).to eq 9
    end

    it "creates a grid upon initialization" do
      expect(world.grid.is_a?(Array)).to be true

      world.grid.each do |r|
        expect(r.is_a?(Array)).to be true
        r.each do |c|
          expect(c.is_a?(Cell)).to be true
        end
      end

    end

    it "returns neighbors for given cell" do
      expect(world).to respond_to(:living_neighbors_for)
    end

    it "detects a neighbor to the north" do
      world.grid[cell.y - 1][cell.x + 1].alive = true
      expect(world.living_neighbors_for(cell).count).to eq 1
    end

    it "detects a neighbor to the east" do
      world.grid[cell.y][cell.x + 1].alive = true
      expect(world.living_neighbors_for(cell).count).to eq 1
    end

    it "detects a neighbor to the south" do
      world.grid[cell.y + 1][cell.x].alive = true
      expect(world.living_neighbors_for(cell).count).to eq 1
    end

    it "detects a neighbor to the west" do
      world.grid[cell.y][cell.x - 1].alive = true
      expect(world.living_neighbors_for(cell).count).to eq 1
    end

    it "detects a neighbor to the north-east" do
      world.grid[cell.y - 1][cell.x + 1].alive = true
      expect(world.living_neighbors_for(cell).count).to eq 1
    end

    it "detects a neighbor to the south-east" do
      world.grid[cell.y + 1][cell.x + 1].alive = true
      expect(world.living_neighbors_for(cell).count).to eq 1
    end

    it "detects a neighbor to the south-west" do
      world.grid[cell.y + 1][cell.x - 1].alive = true
      expect(world.living_neighbors_for(cell).count).to eq 1
    end

    it "detects a neighbor to the north-west" do
      world.grid[cell.y - 1][cell.x - 1].alive = true
      expect(world.living_neighbors_for(cell).count).to eq 1
    end
  end

  context "Cell" do
    let(:cell) { Cell.new }

    it "creates an instance of cell" do
      expect(cell.is_a?(Cell)).to be(true)
    end

    it "responds to alive?" do
      expect(cell).to respond_to(:alive?)
    end

    it "initializes the cell" do
      expect(cell.alive).to be false
      expect(cell).to respond_to(:x)
      expect(cell).to respond_to(:y)
      expect(cell.x).to eq 0
      expect(cell.y).to eq 0
    end
  end

  context "Game" do
    let(:game) { Game.new(world, []) }
    it "creates a new game" do
      expect(game.is_a?(Game)).to be true
    end

    it "responds to it's attribute methods" do
      expect(game).to respond_to(:world)
      expect(game).to respond_to(:seeds)
    end

    it "intializes a game object" do
      expect(game.world.is_a?(World)).to be true
      expect(game.seeds.is_a?(Array)).to be true
    end

    it "seeds the game world" do
      game = Game.new(world, [[1, 0], [1, 1]])
      expect(world.grid[1][0]).to be_alive
      expect(world.grid[1][1]).to be_alive
    end
  end

  context "Rules" do
    let!(:game) { Game.new(world, []) }
    context "Rule #1" do
      # Any live cell with fewer than 2 live neighbors dies
      it "kills a live cell with no neighbors" do
        game.world.grid[1][1].alive = true
        expect(game.world.grid[1][1]).to be_alive
        game.evolve!
        expect(game.world.grid[1][1]).to be_dead
      end

      it "kills a live cell with 1 live neighbor" do
        game = Game.new(world, [[1, 0],[2, 0]])
        game.evolve!

        expect(world.grid[1][0]).to be_dead
        expect(world.grid[2][0]).to be_dead
      end

      it "does not kill a live cell with 2 neighbors" do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        game.evolve!
        expect(world.grid[1][1]).to be_alive
      end
    end

    context "Rule #2" do
      it "Keeps alive any cell with 2 neighbors" do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        expect(world.living_neighbors_for(world.grid[1][1]).count).to eq 2
        game.evolve!
        expect(world.grid[0][1]).to be_dead
        expect(world.grid[1][1]).to be_alive
        expect(world.grid[2][1]).to be_dead
      end

      it "Keeps alive any cell with 3 neighbors" do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1], [2, 2]])
        expect(world.living_neighbors_for(world.grid[1][1]).count).to eq 3
        game.evolve!
        expect(world.grid[0][1]).to be_dead
        expect(world.grid[1][1]).to be_alive
        expect(world.grid[2][1]).to be_alive
        expect(world.grid[2][2]).to be_alive
      end
    end

    context "Rule #3" do
      it "kills a live cell with more than 3 living neighbors" do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1], [2, 2], [1, 2]])
        expect(world.living_neighbors_for(world.grid[1][1]).count).to eq 4
        game.evolve!
        expect(world.grid[0][1]).to be_alive
        expect(world.grid[1][1]).to be_dead
        expect(world.grid[2][1]).to be_alive
        expect(world.grid[2][2]).to be_alive
        expect(world.grid[1][2]).to be_dead
      end
    end

    context "Rule #4" do
      it "revives a dead cell with 3 neighbors" do
        game = Game.new(world, [[0, 1], [1, 1], [2, 1]])
        expect(world.living_neighbors_for(world.grid[1][0]).count).to eq 3
        game.evolve!
        expect(world.grid[1][0]).to be_alive
        expect(world.grid[1][2]).to be_alive
      end
    end
  end
end
