require 'simplecov'

require_relative 'Node'
require 'minitest/autorun'

class NodeTest < MiniTest::Test

	def test_add_path
		node = Node.new('Enumerable Canyon', 3, 4, 6)
		neighbor = Node.new('Monkey Patch City', 3, 4, 6)
		node.add_neighbor(neighbor)
		assert_equal node.paths.length, 1
	end
end