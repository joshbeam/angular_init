# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# PURPOSE: 	Configure "global" options for ngi
# METHOD:   Writes options to angular_init.config.yml, which is read by angular_init
# 			to generate the correct template for the user

# See options in angular_init.config.yml

# Allow users to configure:
# => language (ES5, ES6, CoffeeScript)
# => using custom template
# => using custom type and aliases (for example,
#    by default, "routes" is an alias for a certain
#    type of AngularJS "config" function)

# CURRENT_DIR is defined in angualr_init.rb

require CURRENT_DIR+'/generator'
require CURRENT_DIR+'/configure'

class Manager
	# Review: is this the best way to do it?
	Generator = ::Generator
	Configure = ::Configure

	# So we can call Manager.run(args...)
	class << self
		def run(args)
			commands = args[:config]['global']['commands']

			new_args = {
				:config => args[:config]
			}

			if(args[:command] == commands['make'] && args.has_key?(:type))

				new_args[:type] = args[:type]

				Generator.run(new_args)

			elsif args[:command] == commands['config']

				puts 'TODO: config' 

			end

			# TODO: need global error/exception logger

		end
	end
end