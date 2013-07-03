require 'sinatra'
require 'slim'

require './pizzadata'

LAST_PIZZA_FILENAME = "lastpizza.yml"
LAST_PIZZA = PizzaData.load(LAST_PIZZA_FILENAME)

class JFOP < Sinatra::Base
	def has_ordered_pizza(last_dt)
		# return true if jenn last ordered pizza less than a day ago
		(DateTime.now - last_dt < 1)
	end

	get '/' do
		if LAST_PIZZA then
			time = LAST_PIZZA.time
			msg = LAST_PIZZA.msg
		end

		ordered = (time && has_ordered_pizza(time)) ? "yes" : "no"

		slim :index, locals: {time: time, msg: msg, ordered: ordered}
	end

	get '/submit' do
		if params['magicword'] != ENV['JFOP_MAGIC_WORD'] then
			403
		else
			LAST_PIZZA = PizzaData.new(time: DateTime.now, msg: params['msg'])
			LAST_PIZZA.dump(LAST_PIZZA_FILENAME)

			200
		end
	end
end
