# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# CURRENT_DIR is defined in angualr_init.rb

require_relative '../dep/json'
require_relative 'utils/utils'

# Run the user through an interactive
# session of configuring ngi
class Configure
  attr_accessor :file, :location

  Utils = ::Utils
  JSArray = Utils::JSArray
  JSHash = Utils::JSHash

  # Here, we implement the virtual class "Utils::AskLoop"
  # (see src/ruby/utils/utils.rb)
  # This implementation just creates a loop that asks
  # for user input
  class AskLoop < Utils::AskLoop
    def self.ask(args)
      puts "\nChoose from: #{args[:valid]}"
      answer = $stdin.gets.strip

      loop do
        break if args[:check].include?(answer)
        puts "Choose from: #{args[:valid]}\n(or press ctrl+c to exit)"
        answer = $stdin.gets.strip
      end
      answer
    end
  end

  # Holds all the configure functions for the properties
  # that are configurable
  class Configurable
    def self.language(config)
      v = JSArray.new(config.lang_types).to_str
      type = AskLoop.ask(check: config.lang_types, valid: v)

      curr_lang = config.global['language'][type]
      lang_opts = config.languages[type].reject { |l| l if curr_lang == l }

      v = JSArray.new(lang_opts).to_str
      language = AskLoop.ask(check: lang_opts, valid: v)

      answer = config.global['language']
      answer[type] = language

      answer
    end
  end

  # Make Questioner accesible as in: Configure::Questioner.run()
  # "Questioner" simply starts an interactive prompt to guide
  # the user in configuring src/config/agular_init.config.json,
  # which is a JSON file that holds all the global configurable
  # options (like language to use, templates, etc.)
  class Questioner
    attr_accessor :file
    attr_reader :configurable_properties,
                :languages, :global,
                :configurable, :lang_types

    def initialize(file)
      @file = file

      @global = @file['global']
      # TODO: extend array with this inject function?

      # The options for languages to use
      @languages = @global['languages']

      language_types = @languages.select do |type, languages|
        type if languages.size > 1
      end
      # For example, ['script','markup']
      @lang_types = language_types.collect { |type, _| type }.flatten

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

    # This method delegates to the appropriate
    # Configurable#<method> based on the property
    # that the user has chosen to configure
    # Returns: a Hash of the object, based on the
    # from_json config object from config/angular_init.config.json
    def configure_property(property)
      case property
      when @configurable['language']
        return Configurable.language(self)
      end
    end

    def self.run(file)
      questioner = Questioner.new(file) do |q|
        # First, the user chooses a property
        # to configure (from a list of available
        # properties that *can* be configured)
        property = q.choose_configurable_property

        # #configure_property spits out a hash
        # as the result
        result = q.configure_property(property)

        # The hash that was spit out as the
        # result is "merged" into the original
        # Hash from_json object that came from
        # config/angular_init.config.json
        # and is inside of this instance of Questioner
        q.file['global'][property] = result

        # This just tells the user that we were
        # successful
        result_string_hash = JSHash.new(result).to_str
        puts "#{property.capitalize} set to: #{result_string_hash}"
      end

      # Returns the file so that it can be used
      # (For example, Configure might write this
      # new hash as a JSON file to
      # config/angular_init.config.json)
      questioner.file
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
  # to config/angular_init.config.json
  def write
    new_file = to_json

    File.open(@location, 'w') do |f|
      f.write(new_file)
      f.close
    end
  end

  # All this method does is handle retrieving
  # the file from config/angular_init.config.json
  # so that it can pass it off to Questioner,
  # which can in turn change the Hash and pass it
  # *back* to Configure, which can then choose
  # to actually write the file in JSON format
  # to config/angular_init.config.json
  def self.run(args)
    Configure.new(args[:file_path]) do |c|
      # Get the JSON file as a Ruby Hash
      json_file = c.from_json

      # Pass it off to Questioner so that
      # we can interact with the user and
      # have the user configure the Hash.
      # Then, we set the Configure file
      # to the output of however the user
      # configured it with Questioner
      c.file = Configure::Questioner.run(json_file)

      # We'll write the hash to
      # config/angular_init.config.json.
      # Configure#write converts the Hash
      # to JSON and then uses File.write
      c.write if args[:write] == true
    end
  end
end
