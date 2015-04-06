# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License


# Similar to Ruby's OptionParser
# However, this is customized for angular_init

class CommandParser
	attr_reader :args
	attr_accessor :banner, :version, :separator, :name

	def initialize
		# TODO: to "Usage #{file_name}", etc.
		@name = "<CLI>"
		@banner = "Usage: #{@name} <command>"
		@version = "0.0.0"
		@separator = "===================="
		@listeners = []

		# automatically register some listeners
		register_help
		register_version

		# be able to pass in a block for setup
		if block_given?
			yield(self)
		end
	end

	def name=(name)
		# need to also replace the name in the banner
		@banner = @banner.gsub(@name,name)

		@name = name
	end

	# register the listeners
	def on(options,description="",&block)
		listener = {}

		# be able to pass in a single argument, or an array of arguments
		options = *options unless options.is_a? Array

		listener[:options] = options.map do |opt|
			opt.strip.split(" ")
		end

		listener[:block] = block
		listener[:description] = description

		@listeners << listener
	end

	def parse(args)
		# puts @listeners
		matched_listener = {
			:options => nil,
			:block => nil
		}

		@listeners.each do |listener|
			listener[:options].each do |opt_arr|
				if opt_arr == args
					matched_listener[:options] = opt_arr
					matched_listener[:block] = listener[:block]
					break
				end
			end
		end

		unless matched_listener[:options].nil?
			# matched_listener[:options] should always be an array
			# when we call, we can each member of that array to be
			# passed separately
			matched_listener[:block].call(*matched_listener[:options])
		else
			# if there was no match, show the help menu
			parse(["-h"])
		end
	end

	def register_help
		# automaticaly register this listener
		on(["-h","--help"],"Show the help menu") do
			puts @separator
			puts @banner

			@listeners.each_with_index do |listener,i|
				puts "\n"
				puts "(#{i+1}) #{listener[:description]}: #{listener[:options].join(', ')}"
			end
			puts @separator
		end
	end

	def register_version
		# automaticaly register this listener
		on(["-v","--version"],"Show the version") do
			puts "#{@name} #{@version}"
		end
	end
end