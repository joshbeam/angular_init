# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# This module wraps the basic classes
# of the tool ngi (in other words, this
# module simply provides namespace)
module Ngi
  require_relative 'ngi/delegate'
  require_relative 'ngi/parser'

  # REVIEW: Is this the best way to do it?
  Delegate = ::Delegate
  Parser = ::Parser
end
