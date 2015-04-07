# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

require_relative 'command_parser'
require_relative 'jser'

module Utils
  CommandParser = ::CommandParser
  JSArray = JSer::JSArray
  JSHash = JSer::JSHash

  class AskLoop; end

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
