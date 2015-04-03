# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# CURRENT_DIR is defined in angualr_init.rb

# require CURRENT_DIR+'/../../../lib/json'
# require CURRENT_DIR+'/../utils/utils'

require_relative '../../../lib/json'
require_relative '../utils/utils'

class Configure
	attr_accessor :file, :location

	Utils = ::Utils

	# Here, we implement the virtual class "Utils::AskLoop"
	# (see src/ruby/utils/utils.rb)
	# This implementation just creates a loop that asks
	# for user input
	class Utils::AskLoop
		def self.ask(args)
			answer = $stdin.gets.strip

			while true
				if args[:check].include?(answer)
					break
				else
					puts 'Choose from: '+args[:valid]
					puts '(or press ctrl+c to exit)'
					answer = $stdin.gets.strip
				end
			end

			answer
		end
	end

	# The only thing we do here is load the JSON config file basically
	# as just a string in JSON format.
	# It will be converted to a Ruby hash in from_json below
	def initialize
		@location = CURRENT_DIR+'/../../config/angular_init.config.json'
		@file = IO.read(@location)
	end

	# Convert the file to a Ruby hash
	def from_json
		JSON.parse(@file)
	end

	# Generate a "prettified" JSON version of our
	# newly updated Ruby hash with the user's options
	def to_json
		JSON.pretty_generate(@file)
	end

	# Here we actually write the new JSON config file
	# to src/config/angular_init.config.json
	def write
		new_file = to_json

		File.open(@location,'w') do |f|
			f.write(new_file)
			f.close
		end
	end

	# Make Questioner accesible as in: Configure::Questioner.run()
	# "Questioner" simply starts an interactive prompt to guide
	# the user in configuring src/config/agular_init.config.json,
	# which is a JSON file that holds all the global configurable
	# options (like language to use, templates, etc.)
	class Questioner
		attr_accessor :file

		def initialize(file)
			@file = file

			@GLOBAL = @file['global']
			# TODO: extend array with this inject function?

			# The options for languages to use
			@LANGUAGES = @GLOBAL['languages']

			# Used for displaying the options for a new language to change to
			@LANGUAGES_STRING = @LANGUAGES.select { |l| l != @GLOBAL['language'] }.each_with_index.inject('') { |a,(b,i)| a+=b+(i==@LANGUAGES.size - 2 ? '' : ', ') }

			# The properties in key => value format of the properties the user can configure
			@CONFIGURABLE = @GLOBAL['configurable']

			# An array of the properties that the user is allowed to configure,
			# according to src/config/angular_init.config.json
			@CONFIGURABLE_PROPERTIES = @CONFIGURABLE.collect{ |k,v| v }

			# String version of the allowable configurable properties to display in the command line
			@CONFIGURABLE_STRING = @CONFIGURABLE_PROPERTIES.each_with_index.inject('') { |a,(b,i)| a+=(i+1).to_s+') '+b+(i==@CONFIGURABLE_PROPERTIES.size - 1 ? '' : ', ') }
		end

		def choose_configurable_property
			puts "\nCurrent settings: "
			@CONFIGURABLE.each do | k,v |
				puts "---> "+v.capitalize+": "+@GLOBAL[v].to_s
			end
			puts "\n"
			print 'Type the property you want to configure: '
			puts @CONFIGURABLE_STRING
			puts '(or type ctrl+c to exit)'

			# return
			Utils::AskLoop.ask(:check => @CONFIGURABLE_PROPERTIES, :valid => @CONFIGURABLE_STRING)
		end

		def configure_property(property)
			case property
			when @CONFIGURABLE['language']
				puts "\nChoose from: "+@LANGUAGES_STRING
				# return
				answer = Utils::AskLoop.ask(:check => @LANGUAGES, :valid => @LANGUAGES_STRING)
			end

			# TODO: add ability to add templates

			answer
		end


		def self.run(file)
			q = Questioner.new(file)

			configurable_property = q.choose_configurable_property

			result = q.configure_property(configurable_property)

			q.file['global'][configurable_property] = result

			puts configurable_property.capitalize+' set to: '+result

			#return 
			q.file
		end
	end

	def self.run
		config = Configure.new

		config.file = Configure::Questioner.run(config.from_json)

		config.write
	end
end