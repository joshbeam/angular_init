# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# CURRENT_DIR is defined in angualr_init.rb

# require CURRENT_DIR+'/../../../lib/json'
# require CURRENT_DIR+'/../utils/utils'

require_relative '../dep/json'
require_relative 'utils/utils'

class Configure
	attr_accessor :file, :location

	Utils = ::Utils
	JSArray = Utils::JSArray
	JSHash = Utils::JSHash

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

			# The properties in key => value format of the properties the user can configure
			@CONFIGURABLE = @GLOBAL['configurable']

			# An array of the properties that the user is allowed to configure,
			# according to src/config/angular_init.config.json
			@CONFIGURABLE_PROPERTIES = @CONFIGURABLE.collect{ |k,v| v }

			if block_given?
				yield(self)
			end
		end

		def choose_configurable_property
			line_break = "\n------------------"

			puts "\nCurrent settings #{line_break}"
			@CONFIGURABLE.each_with_index do | (k,v),i |
				puts "#{i+1}) "+v.capitalize+": "+JSHash.new(@GLOBAL[v]).to_str
			end

			# return
			AskLoop.ask(:check => @CONFIGURABLE_PROPERTIES, :valid => JSArray.new(@CONFIGURABLE_PROPERTIES).to_str)
		end

		def configure_property(property)
			case property
			when @CONFIGURABLE['language']
				language_types = @LANGUAGES.collect{|type,languages| type if languages.size > 1 }.reject{|t| t.nil?}

				type = AskLoop.ask(:check => language_types, :valid => JSArray.new(language_types).to_str)

				language_opts = @LANGUAGES.reject{|t,languages| languages if t != type}[type].reject{|l| l == @GLOBAL['language'][type]}

				language = AskLoop.ask(:check => language_opts, :valid => JSArray.new(language_opts).to_str)

				answer = @GLOBAL['language']

				answer[type] = language
			end

			# TODO: add ability to add templates

			answer
		end


		def self.run(file)
			q = Questioner.new(file) do |q|
				configurable_property = q.choose_configurable_property

				result = q.configure_property(configurable_property)

				q.file['global'][configurable_property] = result

				puts configurable_property.capitalize+' set to: '+JSHash.new(result).to_str
			end

			q.file
		end
	end

	# Here, we implement the virtual class "Utils::AskLoop"
	# (see src/ruby/utils/utils.rb)
	# This implementation just creates a loop that asks
	# for user input
	class AskLoop < Utils::AskLoop
		def self.ask(args)
			puts "\n"
			puts 'Choose from: '+args[:valid]

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
		@location = CURRENT_DIR+'/config/angular_init.config.json'
		@file = IO.read(@location)

		if block_given?
			yield(self)
		end
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

	def self.run
		Configure.new do |c|
			c.file = Configure::Questioner.run(c.from_json)

			c.write
		end
	end
end