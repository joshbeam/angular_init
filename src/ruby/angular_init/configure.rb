# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

require CURRENT_DIR+'/../../../lib/json'

class Configure
	def self.get
		c = Configure.new

		JSON.parse(IO.read(CURRENT_DIR+'/../../config/angular_init.config.json'))
	end
end