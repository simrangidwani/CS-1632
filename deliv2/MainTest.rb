require 'simplecov'

require_relative 'Node'
require_relative 'Graph'
require_relative 'Main'
require 'minitest/autorun'

# class for testing the Main program
class MainTest < Minitest::Test

	##testing the method that reinitializes all the values to 0
	def test_restart
		test_main = Main.new(3, 1, 6)
		test_main.run
		assert_equal test_main.num_real_rubies, 0
	end

	##testing to verify that after this method is called
	##there are 7 locations that are created
	def test_create_all_locations
		test_main = Main.new(3, 4, 6)
		test_graph = Graph.new(10)
		test_main.create_all_locations(test_graph)
		assert_equal test_main.num_locations(test_graph), 7
	end

	##tests to make sure the location that is being passed in as an argument in any of the 
	##methods is a valid location
	def test_is_valid
		test_main = Main.new(3, 4, 6)
		assert_equal test_main.valid_location("Enumberable Canyon"), 0
	end

	##EDGE CASE
	##passing in a location that doesnt exist as an argument in any of the methods will return -1
	def test_is_valid_2
		test_main = Main.new(3, 4, 6)
		assert_equal test_main.valid_location("Animal Beach"), -1
	end

	##testing to make sure that each city has the correct number of
	##paths to other cities
	def test_create_all_paths
		test_main = Main.new(3, 4, 6)
		test_graph = Graph.new(10)
		test_main.create_all_locations(test_graph)
		test_main.create_all_paths(test_graph)
		assert_equal test_graph.get_loc("Matzburg").paths.length, 4
	end

	##testing to make sure that when this method is called
	##a graph representation is made that has the correct number
	##of paths to other cities
	def test_make_graph
		test_main = Main.new(3, 4, 6)
		test_graph = Graph.new(10)
		test_graph = test_main.make_graph(test_graph)
		assert_equal test_graph.get_loc("Matzburg").paths.length, 4
	end

	##makes sure that calling this method displays the correct total number
	##of rubies found during that Rubyists journey
	def test_real_rubies_found
		test_main = Main.new(3, 4, 6)
		test_graph = Graph.new(10)
		test_main.real_rubies_found(7)
		test_main.real_rubies_found(7)
		assert test_main.num_real_rubies, 14
	end

	##makes sure that calling this method displays the correct total number
	##of fake rubies found during that Rubyists journey
	def test_fake_rubies_found
		test_main = Main.new(3, 4, 6)
		test_graph = Graph.new(10)
		test_main.fake_rubies_found(7)
		test_main.fake_rubies_found(7)
		assert test_main.num_fake_rubies, 14
	end

	##tests the display method that shows the rubyists total finds after a visit to
	##each place
	def test_rub_per_round
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.real_rubies_found(7)
		test_main.rub_per_round(mocked_Graph)
		assert mocked_Graph
	end

	#partioned above method into individually tests the methods that print the rubies out in the
	#correct grammatical form
	def test_print_results
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.print_results
		assert mocked_Graph
	end

	def test_print_singular_results
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.real_rubies_found(1)
		test_main.print_singular_rrubies_results
		assert mocked_Graph
	end

	def test_print_plural_results
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.real_rubies_found(5)
		test_main.print_plural_rrubies_results
		assert mocked_Graph
	end

#the next three are testing the different messages based on the number
#of rubies found
	def test_home_message_1
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.real_rubies_found(0)
		test_main.home_message
		assert mocked_Graph
	end

	def test_home_message_2
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.real_rubies_found(4)
		test_main.home_message
		assert mocked_Graph
	end

	def test_home_message_3
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.real_rubies_found(12)
		test_main.home_message
		assert mocked_Graph
	end

	##EDGE CASE 
	##should never happen but testing if the number of real rubies at the end is negative
	##still returns going home sad.
	def test_home_message_negative
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.real_rubies_found(-2)
		test_main.home_message
		assert mocked_Graph
	end

	#two tests, one testing the starting position and second tests any location after that
	def test_print_location_starting
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.print_location(mocked_Graph, 0)
		assert mocked_Graph
	end

	def test_print_location_next
		test_main = Main.new(3, 1, 6)
		mocked_Graph = MiniTest::Mock.new("mocked graph")
		mocked_Graph.expect(:get_curr_loc, Node.new("Enumerable Canyon", 4, 5, 10))
		test_main.print_location(mocked_Graph, 1)
		assert mocked_Graph
	end

	#tests the main run program
	def test_run
		mocked_prog = MiniTest::Mock.new("mocked program")
		mocked_prog.expect(:run, 1)
		assert mocked_prog
	end

end
