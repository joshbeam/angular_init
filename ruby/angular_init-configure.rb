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

class Configure
	class << self
		def read(file)
			puts IO.read(file)
		end
	end
end