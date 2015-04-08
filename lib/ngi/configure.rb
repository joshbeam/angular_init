# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# CURRENT_DIR is defined in angualr_init.rb

# require_relative '../dep/json'
require 'json'
require_relative 'utils/utils'

# Run the user through an interactive
# session of configuring ngi
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
    attr_reader :configurable_properties, :languages, :global, :configurable

    def initialize(file)
      @file = file

      @global = @file['global']
      # TODO: extend array with this inject function?

      # The options for languages to use
      @languages = @global['languages']

      # The properties in key => value format
      # of the properties the user can configure
      @configurable = @global['configurable']

      # An array of the properties that the user is allowed to configure,
      # according to src/config/angular_init.config.json
      @configurable_properties = @configurable.collect { |_k, v| v }

      yield(self) if block_given?
    end

    def choose_configurable_property
      @configurable_properties.each_with_index do |p, i|
        puts "#{i + 1}) #{p.capitalize}: #{JSHash.new(@global[p]).to_str}"
      end

      valid = JSArray.new(@configurable_properties).to_str
      # return
      AskLoop.ask(check: @configurable_properties, valid: valid)
    end

    def configure_property(property)
      case property
      when @configurable['language']
        language_types = @languages.select do |type, languages|
          type if languages.size > 1
        end

        language_types = language_types.collect { |type, _| type }.flatten
        valid = JSArray.new(language_types).to_str

        type = AskLoop.ask(check: language_types, valid: valid)

        language_opts = @languages.reject { |t, languages| languages if t != type }[type].reject { |l| l == @global['language'][type] }

        language = AskLoop.ask(check: language_opts, valid: JSArray.new(language_opts).to_str)

        answer = @global['language']

        answer[type] = language
      end

      # TODO: add ability to add templates

      answer
    end

    def self.run(file)
      questioner = Questioner.new(file) do |q|
        configurable_property = q.choose_configurable_property

        result = q.configure_property(configurable_property)

        q.file['global'][configurable_property] = result

        result_string_hash = JSHash.new(result).to_str
        puts "#{configurable_property.capitalize} set to: #{result_string_hash}"
      end

      questioner.file
    end
  end

  # Here, we implement the virtual class "Utils::AskLoop"
  # (see src/ruby/utils/utils.rb)
  # This implementation just creates a loop that asks
  # for user input
  class AskLoop < Utils::AskLoop
    def self.ask(args)
      puts "\nChoose from: #{args[:valid]}"

      answer = $stdin.gets.strip

      loop do
        if args[:check].include?(answer)
          break
        else
          puts "Choose from: #{args[:valid]}\n(or press ctrl+c to exit)"
          answer = $stdin.gets.strip
        end
      end

      answer
    end
  end

  # The only thing we do here is load the JSON config file basically
  # as just a string in JSON format.
  # It will be converted to a Ruby hash in from_json below
  def initialize(location)
    @location = location
    @file = IO.read(@location)

    yield(self) if block_given?
  end

  # Convert the file to a Ruby hash
  def from_json
    JSON.parse(@file)
  end

  # Generate a "prettified" JSON version of our
  # newly updated Ruby hash with the user's options
  def to_json
    if @file.is_a? Hash
      JSON.pretty_generate(@file)
    else
      @file
    end
  end

  # Here we actually write the new JSON config file
  # to src/config/angular_init.config.json
  def write
    new_file = to_json

    File.open(@location, 'w') do |f|
      f.write(new_file)
      f.close
    end
  end

  def self.run(args)
    Configure.new(args[:file_path]) do |c|
      json_file = c.from_json

      c.file = Configure::Questioner.run(json_file)

      c.write if args[:write] == true
    end
  end
end
