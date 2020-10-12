require 'sinatra'
require 'sinatra/reloader'

# main page
get '/' do
	erb :main
end

 get '/display' do
 	# fix later
	#if params.length != 3 or params[:true] == nil or params[:false] == nil or params[:size] == nil
	#	erb :invalidparams
	#end

	truth_table = Array.new
	s = params[:size].to_i
	(2**s).times do |i|
		exp = Array.new
		log_and = true
		log_or = false
		log_xor = false
		log_nand = true

		s.times do |j|
			if ((i/(2**(s-j-1)))%2==1)
				log_or = true
				log_xor = !log_xor
				exp << true
			else
				log_and = false
				log_and = !log_and
				exp << false
			end
		end
		exp << log_and
		exp << log_or
		exp << log_xor
		truth_table << exp
	end
	erb :display, :locals => { trueSym: params[:true], falseSym: params[:false], size: params[:size], truth_table: truth_table}
end

# user attempting to go to a URL other than one specified
not_found do
	status 404
	erb :error
end

