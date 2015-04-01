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

require CURRENT_DIR+'/../../../lib/json'
require CURRENT_DIR+'/generator'

class Manager
	# Review: is this the best way to do it?
	Generator = ::Generator

	class << self
		def run(args)
			config = args[:config]
			type = args[:type]

			Generator.run(:config => config, :type => type) if args[:command] == config['global']['commands']['make']
		end
	end

	class Configure
		def self.get
			c = Configure.new

			JSON.parse(IO.read(CURRENT_DIR+'/../../config/angular_init.config.json'))
		end
	end
end