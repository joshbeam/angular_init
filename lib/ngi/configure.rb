# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# CURRENT_DIR is defined in angualr_init.rb

# TODO: Method to clean out unused custom template files

require_relative 'utils/utils'
require 'fileutils'
require 'yaml'

# Run the user through an interactive
# session of configuring ngi
class Configure
  attr_accessor :file, :location

  Utils = ::Utils
  JSArray = Utils::JSArray
  JSHash = Utils::JSHash
  JSer = Utils::JSer

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
      v = JSer.new(config.lang_types).to_str
      type = AskLoop.ask(check: config.lang_types, valid: v)
      curr_lang = config.config['language'][type]
      lang_opts = config.languages[type].reject { |l| l if curr_lang == l }

      v = JSer.new(lang_opts).to_str
      language = AskLoop.ask(check: lang_opts, valid: v)

      answer = config.config['language']
      answer[type] = language

      answer
    end

    def self.create_template_file(component,config)
      #working_dir = File.basename(Dir.getwd)

      component['language'] = config['language'][component['type']]
      template_dir = "#{CURRENT_DIR}/templates/"
      template_dir << "#{component['type']}/#{component['language']}"
      template_dir << "/#{component['using']}/#{component['template']}"

      destination = File.dirname(template_dir)

      # Create the directory "user" unless it already exists
      FileUtils.mkdir_p(destination) unless File.directory?(destination)

      # The actual custom file
      custom_file = "#{Dir.pwd}/#{component['template']}"

      # Copy the custom file into the new or existing "user" directory
      if File.exist? custom_file
        # TODO: Add a 'safety net' by checking if the user
        # has already added the custom template before
        # so that they don't overwrite it
        FileUtils.cp(custom_file, destination)
      else
        puts "Cannot find custom template file: '#{custom_file}'
Check to make sure the custom template file exists,
and that you're in the correct directory of the custom template."

        exit
      end
    end

    def self.templates(config)
      v = JSer.new(config.components).to_str
      component = AskLoop.ask(check: config.components, valid: v)

      print '[?] Use file: '
      file_name = $stdin.gets.strip

      answer = []

      if config.config.has_key? 'templates'
        answer = config.config['templates']
      end

      answer = answer.reject { |c| c['name'] == component }

      unless file_name == 'default'
        answer << {
          'name' => component,
          'type' => config.components_hash.find { |c| c['name'] == component }['type'],
          'template' => file_name,
          'using' => 'user'
        }

        create_template_file(answer.last, config.config)
      end

      if answer.size == 0
        nil
      else
        answer
      end
    end
  end

  # Make Questioner accesible as in: Configure::Questioner.run()
  # "Questioner" simply starts an interactive prompt to guide
  # the user in configuring src/config/agular_init.config.json,
  # which is a JSON file that holds all the global configurable
  # options (like language to use, templates, etc.)
  class Questioner
    attr_accessor :file
    attr_reader :configurable,
                :languages,
                :config,
                :components,
                :components_hash,
                :lang_types

    def initialize(args)
      @languages = args[:languages]
      language_types = @languages.select do |type, languages|
        type if languages.size > 1
      end
      @lang_types = language_types.collect { |type, _| type }.flatten
      @components_hash = args[:components_hash]
      @components = args[:components]
      @config = args[:config]
      @configurable = args[:configurable]

      yield(self) if block_given?
    end

    def choose_configurable_property
      @configurable.each_with_index do |p, i|
        json_string = 'Default'
        if @config.has_key? p
          json_string = JSer.new(@config[p]).to_str
        end
        puts "#{i + 1}) #{p.capitalize}: #{json_string}"
      end

      valid = JSer.new(@configurable).to_str
      # return
      AskLoop.ask(check: @configurable, valid: valid)
    end

    # This method delegates to the appropriate
    # Configurable#<method> based on the property
    # that the user has chosen to configure
    # Returns: a Hash of the object, based on the
    # from_json config object from config/angular_init.config.json
    def configure_property(property)
      case property
      when 'language'
        return Configurable.language(self)
      when 'templates'
        return Configurable.templates(self)
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
        q.config[property] = result

        # delete any properties that are nil
        q.config.delete_if { |_,v| v.nil? }

        # This just tells the user that we were
        # successful
        result_string_hash = JSer.new(result).to_str rescue 'null'
        puts "#{property.capitalize} set to: #{result_string_hash}"
      end

      # Returns the file so that it can be used
      # (For example, Configure might write this
      # new hash as a JSON file to
      # config/angular_init.config.json)
      questioner.config
    end
  end

  # The only thing we do here is load the JSON config file basically
  # as just a string in JSON format.
  # It will be converted to a Ruby hash in from_json below
  def initialize(location = nil)
    unless location.nil?
      @location = location
      @file = IO.read(@location)
    end

    yield(self) if block_given?
  end

  # Convert the file to a Ruby hash
  # def from_json
  #   JSON.parse(@file)
  # end

  # Convert the file to a Ruby hash
  # Usage: Configure.new('file/path').to_ruby(from: 'yaml')
  def to_ruby(args)
    case args[:from]
    when 'json'
      JSON.parse(@file)
    when 'yaml'
      YAML.load(@file)
    end
  end

  # Convert the file from a Ruby hash
  # into whatever language is specified
  # Usage: <Configure instance>.from_ruby(to: 'yaml')
  def from_ruby(args)
    case args[:to]
    when 'json'
      JSON.pretty_generate(@file)
    when 'yaml'
      @file.to_yaml
    end
  end

  # Here we actually write the new JSON config file
  # to config/angular_init.config.json
  def write(args)
    File.open(args[:destination], 'w') do |f|
      f.write(args[:file])
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
    Configure.new do |c|
      c.file = Configure::Questioner.run(args)

      if args[:write] == true
        c.write(
          destination: args[:destination],
          file: c.from_ruby(to: args[:to])
        )
      end
    end
  end
end
