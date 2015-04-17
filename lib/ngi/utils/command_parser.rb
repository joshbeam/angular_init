# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# Utilities
module Utils
  # Similar to Ruby's OptionParser.
  # However, this is customized for angular_init.
  class CommandParser
    attr_reader :args
    attr_accessor :banner, :version, :separator, :name

    # Create an abstraction of $stdout.puts
    # so that we can test it.
    class Output
      def initialize(str)
        @str = str
      end

      def to_s
        puts @str
      end
    end

    def initialize
      # TODO: to "Usage #{file_name}", etc.
      @name = '<CLI>'
      @banner = "Usage: #{@name} <command>"
      @version = '0.0.0'
      @separator = '===================='
      @listeners = []

      # automatically register some listeners
      register_help
      register_version

      # be able to pass in a block for setup
      yield(self) if block_given?
    end

    def name=(name)
      # need to also replace the name in the banner
      @banner = @banner.gsub(@name, name)

      @name = name
    end

    # Register the listeners.
    def on(options, description = '', &block)
      listener = {}

      # be able to pass in a single argument, or an array of arguments
      options = *options unless options.is_a? Array

      listener[:options] = options.map do |opt|
        opt.strip.split(' ')
      end

      listener[:block] = block
      listener[:description] = description

      @listeners << listener
    end

    def parse(args)
      # puts @listeners
      matched_listener = {
        options: nil,
        block: nil
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

      if !matched_listener[:options].nil?
        # matched_listener[:options] should always be an array
        # when we call, we can each member of that array to be
        # passed separately
        matched_listener[:block].call(*matched_listener[:options])
      else
        # if there was no match, show the help menu
        parse(['-h'])
      end
    end

    # Automatically register the "help" listener
    def register_help
      # automaticaly register this listener
      on(['-h', '--help'], 'Show the help menu') do
        Output.new(@separator).to_s
        Output.new(@banner).to_s

        @listeners.each_with_index do |listener, i|
          desc = "\n" << "(#{i + 1}) #{listener[:description]}: "
          desc << "#{listener[:options].join(', ')}"
          Output.new(desc).to_s
        end
        Output.new(@separator).to_s
      end
    end

    def register_version
      # automaticaly register this listener
      on(['-v', '--version'], 'Show the version') do
        Output.new("#{@name} #{@version}").to_s
      end
    end
  end
end
