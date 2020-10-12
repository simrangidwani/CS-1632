require_relative 'Node'
require_relative 'Graph'

# main program
class Main
  def initialize(seed, num_prospectors, num_turns)
    @seed = seed
    @num_prospectors = num_prospectors
    @num_turns = num_turns
    @starting_loc = 'Enumberable Canyon'
    @curr_prospector = 1
    @rand_rub_gen = Random.new(seed)
    @loc_array = ['Enumerable Canyon', 'Duck Type Beach', 'Matzburg', 'Dynamic Palisades', 'Hash Crossing', 'Nil Town', 'Monkey Patch City']
    restart
  end

  def restart
    @fake_rubies = 0
    @real_rubies = 0
    @f_round = 0
    @r_round = 0
    @days = 0
  end

  def create_all_locations(graph)
    enum_canyon = Node.new('Enumerable Canyon', 1, 1, @seed)
    dt_beach = Node.new('Duck Type Beach', 2, 2, @seed)
    matz = Node.new('Matzburg', 3, 0, @seed)
    dy_pal = Node.new('Dynamic Palisades', 2, 2, @seed)
    hash_cross = Node.new('Hash Crossing', 2, 2, @seed)
    nil_town = Node.new('Nil Town', 0, 3, @seed)
    mp_city = Node.new('Monkey Patch City', 1, 1, @seed)
    graph.add_location(enum_canyon)
    graph.add_location(dt_beach)
    graph.add_location(matz)
    graph.add_location(dy_pal)
    graph.add_location(hash_cross)
    graph.add_location(nil_town)
    graph.add_location(mp_city)
    graph
  end

  def create_all_paths(graph)
    graph.add_path('Enumerable Canyon', 'Monkey Patch City')
    graph.add_path('Enumerable Canyon', 'Duck Type Beach')
    graph.add_path('Duck Type Beach', 'Matzburg')
    graph.add_path('Monkey Patch City', 'Matzburg')
    graph.add_path('Monkey Patch City', 'Nil Town')
    graph.add_path('Matzburg', 'Dynamic Palisades')
    graph.add_path('Matzburg', 'Hash Crossing')
    graph.add_path('Hash Crossing', 'Dynamic Palisades')
    graph.add_path('Hash Crossing', 'Nil Town')
    graph
  end

  def make_graph(graph)
    graph = create_all_locations(graph)
    graph = create_all_paths(graph)
    graph
  end

  def real_rubies_found(r_rubies)
    @real_rubies += r_rubies
    @r_round = r_rubies
  end

  def randgen_rrubies_found(graph)
    if graph.get_curr_loc.max_real_rubies > 0
      rubies = @rand_rub_gen.rand(graph.get_curr_loc.max_real_rubies + 1)
    else
      rubies = 0
    end
    real_rubies_found(rubies)
    graph
  end

  def fake_rubies_found(f_rubies)
    @fake_rubies += f_rubies
    @f_round = f_rubies
  end

  def randgen_frubies_found(graph)
    if graph.get_curr_loc.max_fake_rubies > 0
      rubies = @rand_rub_gen.rand(graph.get_curr_loc.max_real_rubies + 1)
    else
      rubies = 0
    end
    fake_rubies_found(rubies)
    graph
  end

  def prog_start(graph)
    visits = 0
    while visits < @num_turns
      print_location(graph, visits)
      calculate_rubies(graph)
      if visits < @num_turns - 1
        calculate_rubies_without_display(graph)
        while @r_round != 0 || @f_round != 0
          calculate_rubies(graph)
        end
      else
        calculate_rubies_without_display(graph)
        while @r_round > 1 || @f_round > 1
          calculate_rubies(graph)
        end
      end
      calculate_rubies_without_display(graph)
      @starting_loc = graph.get_curr_loc.location
      graph.next_path
      visits += 1
      @days +=1
    end
    print_results
    home_message
    restart
  end

  def calculate_rubies_without_display(graph)
    randgen_rrubies_found(graph)
    randgen_frubies_found(graph)
  end

  def calculate_rubies(graph)
    randgen_rrubies_found(graph)
    randgen_frubies_found(graph)
    rub_per_round(graph)
    @days += 1
  end

  def rub_per_round(graph)
    if @r_round.zero? && @f_round == 1
      print "\tFound #{@f_round} fake ruby in #{graph.get_curr_loc.location}.\n"
    elsif @r_round == 1 && @f_round.zero?
      print "\tFound #{@r_round} ruby in #{graph.get_curr_loc.location}.\n"
    elsif @r_round == 1 && @f_round == 1
      print "\tFound #{@r_round} ruby in #{graph.get_curr_loc.location}.\n"
      print "\tFound #{@f_round} fake rubies in "
      print "#{graph.get_curr_loc.location}.\n"
    elsif @r_round.zero? && @f_round.zero?
      print "\tFound no rubies or fake rubies in "
      print "#{graph.get_curr_loc.location}.\n"
    elsif @r_round > 1 && @f_round.zero?
      print "\tFound #{@r_round} rubies in #{graph.get_curr_loc.location}.\n"
    elsif @r_round.zero? && @f_round > 1
      print "\tFound #{@f_round} rubies in #{graph.get_curr_loc.location}.\n"
    else
      print "\tFound #{@r_round} rubies in #{graph.get_curr_loc.location}.\n"
      print "\tFound #{@f_round} fake rubies in "
      print "#{graph.get_curr_loc.location}.\n"
    end
  end

  def print_results
    print "After #{@days} days, Rubyist ##{@curr_prospector} found:\n"
    if @real_rubies == 1
      print_singular_rrubies_results
    else
      print_plural_rrubies_results
    end
    if @fake_rubies == 1
      print_singular_frubies_results
    else
      print_plural_frubies_results
    end
  end

  def print_singular_rrubies_results
    print "\t#{@real_rubies} real ruby.\n"
  end

  def print_singular_frubies_results
    print "\t#{@fake_rubies} fake ruby.\n"
  end

  def print_plural_rrubies_results
    print "\t#{@real_rubies} real rubies.\n"
  end

  def print_plural_frubies_results
    print "\t#{@fake_rubies} fake rubies.\n"
  end

  def home_message
    if @real_rubies > 10
      puts 'Going home victorious!'
    elsif @real_rubies.zero?
      puts 'Going home empty-handed.'
    else
      puts 'Going home sad.'
    end
  end

  def valid_location(location)
    if location == 'Enumberable Canyon' || location == 'Monkey Patch City' || location == 'Duck Type Beach' || location == 'Dynamic Palisades' || location == 'Matzburg' || location == 'Hash Crossing' || location == 'Nil Town'
      0
    else
      -1
    end
  end

  def print_location(graph, num_turns)
    if num_turns.zero?
      print "Rubyist #", @curr_prospector, " starting in Enumerable Canyon.\n"
    else
      print "Heading from #{@starting_loc} to #{graph.get_curr_loc.location}, "
      print "holding #{@real_rubies} real rubies and #{@fake_rubies} "
      print "fake rubies.\n"
    end
  end

  def run
    while @num_prospectors > 0
      g = Graph.new(@seed)
      g = make_graph(g)
      prog_start(g)
      @num_prospectors -= 1
      @curr_prospector += 1
    end
  end

  def num_locations(graph)
    graph.num_paths
  end

  def num_real_rubies
    @real_rubies
  end

  def num_fake_rubies
    @fake_rubies
  end
end
