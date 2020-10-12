# Transaction class
class Transaction
  attr_accessor :from_addr, :to_addr, :num_billcoins_sent, :t_string

  def initialize(from_addr, to_addr, num_billcoins_sent)
    @from_addr = from_addr
    @to_addr = to_addr
    @num_billcoins_sent = num_billcoins_sent
    @t_string = "#{from}>#{to}(#{num_billcoin_sent})"
  end
end
