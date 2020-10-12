require_relative 'Node'

# Creates a psuedographical representation of the locations
class Graph
  def initialize(seed)
    @num_cities = 0
    @curr_loc = nil
    @nodes = {}
    @seed = seed
    @rand_num_gen = Random.new(seed)
  end

  def get_curr_loc
    @curr_loc
  end

  def next_path
    next_int = @rand_num_gen.rand(get_curr_loc.paths.length)
    @curr_loc = @nodes[@curr_loc.paths[next_int]]
    @curr_loc
  end

  def num_paths
    @num_cities
  end

  def add_location(loc)
    if @num_cities.zero?
      @curr_loc = loc
    end
    @nodes[loc.location] = loc
    @num_cities += 1
  end

  def get_loc(location_num)
    @nodes[location_num]
  end

  def add_path(loc1, loc2)
    path1 = get_loc(loc1)
    path2 = get_loc(loc2)
    path1.add_neighbor(loc2)
    path2.add_neighbor(loc1)
  end
end
