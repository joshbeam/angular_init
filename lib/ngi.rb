# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

CURRENT_DIR = File.dirname(__FILE__)

require_relative 'ngi/delegate'
require_relative 'ngi/utils/utils'
require_relative 'ngi/version'
require_relative 'ngi/parser'

# This module wraps the basic classes
# of the tool ngi (in other words, this
# module simply provides namespace)
module Ngi
  # REVIEW: Is this the best way to do it?
  Delegate = ::Delegate
  # UserInput = ::Utils::UserInput
  Parser = ::Parser
end
