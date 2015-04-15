# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# Generator and Configure are "wrapped" in this class
# that "delegates" (hence the name "Delegate")
# the flow of control to either the Generator class
# or the Configure class, based on the argument passed
# in (which is handled by bin/ngi)
class Delegate
  require_relative 'generator'
  require_relative 'configure'

  Generator = ::Generator
  Configure = ::Configure
end
