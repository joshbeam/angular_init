# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# Utilities
module Utils
  # This class is just a way to meaningfully
  # collect an array of valid user inputs
  # for use with OptionParser in bin/ngi
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
