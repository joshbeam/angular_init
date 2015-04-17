# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# This module holds classes of basic utility
# functions used throughout Ngi
module Utils
  require_relative 'command_parser'
  require_relative 'jser'
  require_relative 'user_input'
  require_relative 'current_dir'

  # These are just "virtual" classes
  # that are later implemented.
  class AskLoop; end
  class AcceptInput; end
  class TemplateDir; end
end
