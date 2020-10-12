# Node class that creates all the locations
class Node
  attr_accessor :max_fake_rubies
  attr_accessor :max_real_rubies
  attr_accessor :location
  attr_accessor :paths

  def initialize(location, max_real_rubies, max_fake_rubies, seed)
    @seed = seed
    @location = location
    @max_fake_rubies = max_fake_rubies
    @max_real_rubies = max_real_rubies
    @paths = []
  end

  def add_neighbor(neighbor)
    @paths << neighbor
  end
end
