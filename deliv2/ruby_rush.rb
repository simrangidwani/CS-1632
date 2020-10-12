require_relative 'Main'
require_relative 'Graph'
require_relative 'Node'

# Class running all the other class files
def show_usage_message
  puts('Usage: ')
  puts('ruby ruby_rush.rb *seed* *num_prospectors* *num_turns*')
  puts('*seed* should be an integer')
  puts('*num_prospectors* should be a non-negative integer')
  puts('*num_turns* should be a non-negative integer')
  exit(1)
end

def arg_check(args)
  args.count == 3
rescue StandardError
  false
end

args_valid = arg_check ARGV

if args_valid
  ruby_rush = Main.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
  ruby_rush.run
else
  show_usage_message
end
