# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

require CURRENT_DIR+'/../../../lib/json'
require CURRENT_DIR+'/../utils/utils'

class Configure
	attr_accessor :file, :location

	Utils = ::Utils

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

	def initialize
		@location = CURRENT_DIR+'/../../config/angular_init.config.json'
		@file = IO.read(@location)
	end

	def from_json
		JSON.parse(@file)
	end

	def to_json
		JSON.pretty_generate(@file)
	end

	def write
		new_file = to_json

		File.open(@location,'w') do |f|
			f.write(new_file)
			f.close
		end
	end

	# make Questioner accesible like: Configure::Questioner.run()
	class Questioner
		attr_accessor :file

		def initialize(file)
			@file = file
			@GLOBAL = @file['global']
			# TODO: extend array with this inject function?
			@LANGUAGES = @GLOBAL['languages']
			@LANGUAGES_STRING = @LANGUAGES.each_with_index.inject('') { |a,(b,i)| a+=b+(i==@LANGUAGES.size - 1 ? '' : ', ') }
			@CONFIGURABLE = @GLOBAL['configurable']
			@CONFIGURABLE_PROPERTIES = @CONFIGURABLE.collect{ |k,v| v }
			@CONFIGURABLE_STRING = @CONFIGURABLE_PROPERTIES.each_with_index.inject('') { |a,(b,i)| a+=b+(i==@CONFIGURABLE_PROPERTIES.size - 1 ? '' : ', ') }
		end

		def choose_configurable_property
			print 'Type the property you want to configure: '
			puts @CONFIGURABLE_STRING

			# return
			Utils::AskLoop.ask(:check => @CONFIGURABLE_PROPERTIES, :valid => @CONFIGURABLE_STRING)
		end

		def configure_property(property)
			case property
			when @CONFIGURABLE['language']
				puts 'Choose from: '+@LANGUAGES_STRING
				# return
				answer = Utils::AskLoop.ask(:check => @LANGUAGES, :valid => @LANGUAGES_STRING)
			end

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