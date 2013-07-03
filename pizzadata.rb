require 'yaml'

class PizzaData
	attr_accessor :time
	attr_accessor :msg

	def initialize(args)
		self.time = args[:time]
		self.msg = args[:msg]
	end

	def self.load(filename)
		if !File.exists?(filename) then
			nil
		else
			PizzaData.new(YAML.load_file(filename))
		end
	end

	def dump(filename)
		File.open(filename, 'w') do |io|
			YAML.dump(
				{ time: self.time, msg: self.msg }, 
				io
			)
		end
	end
end
