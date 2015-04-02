# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

CURRENT_DIR = File.dirname(__FILE__)

require CURRENT_DIR+'/manager'
require CURRENT_DIR+'/commands'
require CURRENT_DIR+'/menus'


module AngularInit
	# REVIEW: Is this the best way to do it?
	Manager = ::Manager
	Commands = ::Commands
	Menus = ::Menus
end