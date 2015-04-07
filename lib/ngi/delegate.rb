# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# CURRENT_DIR is defined in angualr_init.rb

# require CURRENT_DIR+'/generator'
# require CURRENT_DIR+'/configure'

require_relative 'generator'
require_relative 'configure'

# Generator and Configure are "wrapped" in this class
# that "delegates" (hence the name "Delegate")
# the flow of control to either the Generator class
# or the Configure class, based on the argument passed
# in (which is handled by bin/ngi)
class Delegate
  Generator = ::Generator
  Configure = ::Configure
end
