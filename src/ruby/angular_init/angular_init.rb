# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

CURRENT_DIR = File.dirname(__FILE__)

require_relative 'delegate'
require_relative 'commands'
require_relative 'menus'


module AngularInit
	VERSION = '0.1.1'
	# REVIEW: Is this the best way to do it?
	Delegate = ::Delegate
	Commands = ::Commands
	Menus = ::Menus
end