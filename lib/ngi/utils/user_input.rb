# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# Utilities
module Utils
  # This class is just a way to meaningfully
  # collect an array of valid user inputs
  # for use with CommandParser.
  class UserInput
    attr_reader :valid_inputs

    # Here we collect all the valid inputs.
    def initialize(args)
      @valid_inputs = args[:valid_inputs]
    end

    # Here we compare an input against
    # the array of valid inputs that was
    # set whenever we created an instance of this.
    def valid?(input)
      @valid_inputs.include?(input)
    end
  end
end
