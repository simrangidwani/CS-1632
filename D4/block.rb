# Block holds a list of transactions associated with that block
class Block
  attr_accessor :block_num, :prev_hash, :seq_trans, :timestamp, :curr_hash, :correct

  def initialize(block_num, prev_hash, seq_trans, timestamp, curr_hash)
    @block_num = block_num
    @prev_hash = prev_hash
    @seq_trans = seq_trans
    @timestamp = timestamp
    @curr_hash = curr_hash
  end

  def hash
    string_to_hash = "#{block_num}|#{prev_hash}|#{seq_trans}|#{timestamp}"
    unpacked_string = string_to_hash.unpack('U*')
    sum = 0
    unpacked_string.each do |x|
      val = ((x**3000) + (x**x) - (3**x)) * (7**x)
      sum += val
    end
    value = sum % 65_536
    value.to_s(16)
  end
end
