require_relative 'block'
require_relative 'transaction'
#require 'flamegraph'

class Verifier
  attr_accessor :input, :blockchain, :blocks, :balance, :transactions
  
  def self.initialize(blockchain, blocks, balance)
    @blockchain = blockchain
    @blocks = blocks
    @balance = balance
  end

  def self.blockchain=(value)
    @blockchain = value
  end

  def self.blockchain
    @blockchain
  end

  def self.blocks=(value)
    @blocks = value
  end

  def self.blocks
    @blocks
  end

  def self.argscheck
    if ARGV.length != 1
      puts "Please enter only the file name! Program exiting..."
      exit 0
    else
      args = ARGV[0]
    end
    return args
  end

  def self.check_empty_file(args)
    @input = args

    if File.zero?(@input)
      puts "File is empty. Program exiting..."
      exit 0
    else
      blockchain = read_lines(@input)
      blocks = partition(blockchain)
      balance = Hash.new(0)
    end
    initialize(blockchain, blocks, balance)
  end


  def self.read_lines(data_in)
    blockchain_split = []
    blockchain_split = IO.readlines(data_in)
    return blockchain_split
  end

  def self.partition(data_in)
    data_out = []
    i = 0
    while i < data_in.count
      block_partitions = data_in[i].split('|')
      data_out[i] = Block.new(block_partitions[0].to_i, block_partitions[1], block_partitions[2], block_partitions[3], block_partitions[4])
      i += 1
    end
    return data_out
  end

  def self.check_transactions
    transactions_semicolon_split = []
    i = 0
    while i < @blocks.count
      transactions_semicolon_split = @blocks[i].seq_trans.split(':')
      j = 0
      while j < transactions_semicolon_split.count
        @transactions = []
        transaction_partitions = transactions_semicolon_split[j].split(/>|[()]/) 
        @transactions[j] = Transaction.new(transaction_partitions[0], transaction_partitions[1], transaction_partitions[2].to_i)
        
        if !@transactions[j].from_addr.strip.eql? "SYSTEM"
          @balance[@transactions[j].from_addr] -= @transactions[j].num_billcoins_sent
        end
        
        @balance[@transactions[j].to_addr] +=  @transactions[j].num_billcoins_sent
        #HERE
        if check_balances(i) == -1
          puts "BLOCKCHAIN INVALID"
          exit 0
        end
        
        check_from_addr_length(@blocks[i], @transactions[j])
        check_to_addr_length(@blocks[i], @transactions[j])
        check_from_addr_invalid_char(@blocks[i], @transactions[j])
        check_to_addr_invalid_char(@blocks[i], @transactions[j])
        
        if i == @blocks.count - 1
          if j == transactions_semicolon_split.count - 1
            if !@transactions[j].from_addr.strip.eql? "SYSTEM"
              puts "Line #{@blocks[i].block_num}: the last transaction in #{transactions[j].t_string} should be from SYSTEM."
              return -1
            end
            if @transactions[j].num_billcoins_sent != 100
              puts "Line #{@blocks[i].block_num}: the last transaction in #{transactions[j].t_string} SYSTEM should have sent 100 billcoins."
              return -1
            end
          end
        end
        
        j += 1
      end
      i += 1
    end
    return 1
  end

  def self.check_from_addr_length(block, transaction)
    if transaction.from_addr.length > 6
      puts "Line #{block.block_num}: the from address #{transaction.from_addr} is too long."
      return -1
    end
    return 1
  end

  def self.check_to_addr_length(block, transaction)
    if transaction.to_addr.length > 6
      puts "Line #{block.block_num}: the from address #{transaction.to_addr} is too long."
      return -1
    end
    return 1
  end

  def self.check_from_addr_invalid_char(block, transaction)
    if transaction.from_addr.match(/[A-Z]|[a-z]/)
      #puts "Line #{block.block_num}: the from address #{transaction.from_addr} contains an invalid character."
      return -1
    end
    return 1
  end

  def self.check_to_addr_invalid_char(block, transaction)
    if transaction.to_addr.match(/[A-Z]|[a-z]/)
      puts "Line #{block.block_num}: the from address #{transaction.to_addr} contains an invalid character."
      return -1
    end
    return 1
  end


  def self.check_balances(i)
    @balance.each do |key, value|
      if value < 0
        puts "Line #{@blocks[i].block_num}: Invalid block, address #{key} has #{value} billcoins!"
        return -1
      end
    end
    return 1
  end

  def self.check_timestamps(block1, block2)
    timestamp_one_string_partitions = block1.timestamp.split('.')
    timestamp_two_string_partitions = block2.timestamp.split('.')

    timestamp_one_partitions = timestamp_one_string_partitions.map(&:to_i)
    timestamp_two_partitions = timestamp_two_string_partitions.map(&:to_i)

    if timestamp_two_partitions[0] < timestamp_one_partitions[0]
      puts "Line #{block2.block_num}: Previous timestamp #{block1.timestamp} >= new timestamp #{block2.timestamp}"
      return -1
    end

    if timestamp_two_partitions[0] == timestamp_one_partitions[0]
      if timestamp_two_partitions[1] <= timestamp_one_partitions[1]
        puts "Line #{block2.block_num}: Previous timestamp #{block1.timestamp} >= new timestamp #{block2.timestamp}"
        return -1
      end
    end
    return 1
  end

  def self.check_block_num(index_number, block)
    if index_number != block.block_num
      puts "Invalid block number #{block.block_num}, should be #{index_number}"
      return -1
    end
    return 1
  end

  def self.compare_hashes(block)
    correct = block.hash_block
    if !correct.strip.eql? block.curr_hash.strip
      puts "Line #{block.block_num}: String '#{block.block_num}|#{block.prev_hash}|#{block.seq_trans}|#{block.timestamp}' hash set to #{block.curr_hash.strip}, should be #{correct}"
      return -1
    end
    return 1
  end

  def self.check_prev(block1, block2)
    if !block2.prev_hash.strip.eql? block1.curr_hash.strip
      puts "Line #{block2.block_num}: Previous hash was #{block2.prev_hash.strip}, should be #{block1.curr_hash.strip}"
      return -1
    end
    return 1
  end

  def self.check_zero_prev_hash(block)
    if !block.prev_hash.eql? "0"
      puts "Line #{block.block_num}: Previous hash was #{block.prev_hash.strip}, should be 0"
      return -1
    end
    return 1
  end

  def self.print_outcome
    @balance.sort_by{ |key, value| key}.each do |key, value|
      if value > 0
        puts "#{key}: #{value} billcoins"
      end
    end
  end

  def self.run
    Verifier.check_empty_file(argscheck)
    if check_transactions == -1
      puts "BLOCKCHAIN INVALID"
      exit 0
    end
    
    if @blocks.count > 1
      i = 1
      while i < @blocks.count
        if check_timestamps(@blocks[i-1], @blocks[i]) == -1
          puts "BLOCKCHAIN INVALID"
          exit 0
        end
        if check_prev(@blocks[i-1], @blocks[i]) == -1
          puts "BLOCKCHAIN INVALID"
          exit 0
        end
        i += 1
      end
    end

    j = 0
    while j < @blocks.count 
      if check_block_num(j, @blocks[j]) == -1
        puts "BLOCKCHAIN INVALID"
        exit 0
      end
      if compare_hashes(@blocks[j]) == -1
        puts "BLOCKCHAIN INVALID"
        exit 0
      end
      j +=1
    end
    
    if check_zero_prev_hash(@blocks[0]) == -1
      puts "BLOCKCHAIN INVALID"
      exit 0
    end
    print_outcome
  end
end

#Flamegraph.generate('flamegrapher.html') do
  Verifier.run
#end

