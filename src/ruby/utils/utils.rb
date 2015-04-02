# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

module Utils
	class AskLoop; end
	class UserInput
		attr_reader :valid_inputs
		
		def initialize(args)
			@valid_inputs = args[:valid_inputs]
		end

		def valid?(input)
			@valid_inputs.include?(input)
		end
	end
end