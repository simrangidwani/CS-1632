require 'simplecov'

require_relative 'Node'
require_relative 'Graph'
require 'minitest/autorun'

class GraphTest < MiniTest::Test
	def setup
		@g = Graph.new(10)
	end
	# testing to make sure calling add location actually
	# creates a new node
	def test_add_location
		node = Node.new("Enumerable Canyon", 3, 4, 6)
		@g.add_location(node)
		assert_equal @g.num_paths, 1
	end

	# testing the current location method to make sure 
	# when its called it returns the correct current location
	def test_get_curr_loc
		node = Node.new('Enumberable Canyon', 3, 4, 6)
		@g.add_location(node)
		assert_equal "Enumberable Canyon", @g.get_curr_loc.location
	end

	# testing that the next path method returns one of the paths from the current location
	def test_next_path
		node = Node.new("Enumberable Canyon", 3, 4, 6)
		node1 = Node.new("Monkey Patch City", 3, 4, 6)
		@g.add_location(node)
		@g.add_location(node1)
		@g.add_path("Enumberable Canyon", "Monkey Patch City")
		nextNode = @g.next_path
		assert_equal nextNode.location, "Monkey Patch City"
	end

end
