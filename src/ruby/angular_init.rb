# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# MIT License

CURRENT_DIR = File.dirname(__FILE__)

require CURRENT_DIR+'/angular_init-configure'
require CURRENT_DIR+'/angular_init-generator'

module AngularInit
	# REVIEW: Is this the best way to do it?
	Configure = ::Configure
	Generator = ::Generator
end

