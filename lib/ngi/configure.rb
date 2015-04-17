# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# TODO: Method to clean out unused custom template files

require_relative 'utils/utils'
require 'fileutils'
require 'yaml'

# This class handles configuring Ngi.
# It is divided into basically two parts.
# The first part collects user input in the
# command line in sort of an interactive
# Q&A session, and the second part is involved
# in manipulating the configuration files,
# which are stored in lib/config. THe configuration
# file that stores the user's config
# information is actually lib/config/config.yml.
# All the other files in lib/config are supporting
# files that hold default, unchangeable information.
class Configure
  attr_accessor :file, :location

  JSer = Utils::JSer
  Utils::CurrentDir.dir = File.dirname(__FILE__)

  # This class is used in place of just
  # using $stdin.gets (or similar methods)
  # to collect input. This is so that
  # this class can be redefined in tests,
  # basically making #gets testable because
  # it can be replaced with whatever you want.
  class AcceptInput < Utils::AcceptInput
    def self.str(type)
      case type
      when :stripped
        $stdin.gets.strip
      end
    end
  end

  # This implementation just creates a loop that asks
  # for user input in the format of
  # "Choose from: <options>". The result of the
  # user's input is returned so that it can be
  # used later in the code.
  class AskLoop < Utils::AskLoop
    # Starts the loop and waits for user
    # input.
    def self.ask(args)
      puts "\nChoose from: #{args[:valid]}"
      answer = AcceptInput.str(:stripped)

      loop do
        break if args[:check].include?(answer)
        puts "Choose from: #{args[:valid]}\n(or press ctrl+c to exit)"
        answer = AcceptInput.str(:stripped)
      end
      answer
    end
  end

  # An extraction of the template file/directory.
  # This way it can be separated, redefined,
  # and tested.
  class TemplateDir < Utils::TemplateDir
    attr_reader :d

    def initialize(component, language, template)
      @d = "#{Utils::CurrentDir.dir}/templates/"
      @d << "#{component['type']}/#{language}"
      @d << "/user/#{template}"
    end

    def read
      f = File.open(@d)
      content = f.read
      f.close

      content
    end
  end

  # Holds all the configure functions for the properties
  # that are configurable. lib/config/config.configurable.yml
  # holds a list of the properties that the user is allowed
  # to configure.
  class Configurable
    # Allows the user to define the language
    # of the languages that they are allowed to configure.
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

    # This method creates the actual template file
    # by copying the user's custom template file
    # into ngi's templates directory.
    # This method is used inside of #self.templates
    def self.create_template_file(args)
      component = args[:component]
      language = args[:language]
      template = args[:template]

      template_dir = TemplateDir.new(component, language, template).d

      destination = File.dirname(template_dir)

      # Create the directory "user" unless it already exists
      FileUtils.mkdir_p(destination) unless File.directory?(destination)

      # The actual custom file
      custom_file = template

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

    # Allows the user to configure the templates for the various
    # components, like directives, controllers, etc.
    def self.templates(config)
      v_c = JSer.new(config.components).to_str
      component = AskLoop.ask(check: config.components, valid: v_c)
      chosen_component = -> (c) { c['name'] == component }

      print '[?] Use the following template file: '
      file_name = AcceptInput.str(:stripped)

      print '[?] What language is this template for?'
      type = config.components_hash.find(&chosen_component)['type']
      v_l = JSer.new(config.languages[type]).to_str
      language = AskLoop.ask(check: config.languages[type], valid: v_l)
      chosen_language = -> (t) { t['language'] == language }

      # Our answer will be an empty array first,
      # because Tempaltes: might not exist the
      # config.yml file
      answer = []

      # Set the answer to Templates: from the config.yml
      # file if it exists
      answer = config.config['templates'] if config.config.key? 'templates'

      # Then we want to see if the component already exists in
      # the config file
      exists = false
      existing_component = answer.find(&chosen_component)
      exists = true if !existing_component == false

      if file_name != 'default'
        if exists == true
          # Remove the current existing component (it's already saved above)
          answer = answer
                   .reject(&chosen_component)

          # Remove the existing template object
          existing_component['templates'] = existing_component['templates']
                                            .reject(&chosen_language)

          # Put in the updated template object
          existing_component['templates'] << {
            'language' => language,
            'template' => file_name
          }

          # Push the existing component back into the templates array
          answer << existing_component

        elsif exists == false

          # If it isn't already there,
          # go ahead and add it to the templates array
          answer << {
            'name' => component,
            'type' => type,
            'templates' => [
              {
                'language' => language,
                'template' => file_name
              }
            ]
          }
        end

        create_template_file(
          config: config.config,
          component: answer.last,
          language: language,
          template: file_name
        )
      else
        # If default is chosen as the template,
        # then delete the template from the templates
        # array for that component
        answer
          .find(&chosen_component)['templates']
          .delete_if(&chosen_language)

        # If the templates array of the component
        # is empty, then delete the entire component
        # from the answer
        answer
          .delete_if(&chosen_component) if answer
                                           .find(&chosen_component)['templates']
                                           .size == 0
      end

      if answer.size == 0
        nil
      else
        answer
      end
    end
  end

  # Make Questioner accesible as in: Configure::Questioner.run().
  # Questioner simply starts an interactive prompt to guide
  # the user in configuring ngi,
  # which is a file that holds all the global configurable
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
      puts "Current settings\n================"
      @configurable.each_with_index do |p, i|
        json_string = 'Currently using default settings'
        json_string = JSer.new(@config[p]).to_str if @config.key? p
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

    # Creates a new instance of Questioner and
    # in a "functional programming" sort of way,
    # runs through the various methods of choosing
    # a configurable property based on the user's
    # input and configuring that property.
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
        # Hash object that came from
        # config/config.yml
        # and is inside of this instance of Questioner
        q.config[property] = result

        # delete any properties that are nil
        q.config.delete_if { |_, v| v.nil? }

        # This just tells the user that we were
        # successful
        result_string_hash = JSer.new(result).to_str rescue 'null'
        puts "#{property.capitalize} set to: #{result_string_hash}"
      end

      # Returns the file so that it can be used
      questioner.config
    end
  end

  # The only thing we do here is load the config file
  # as just a string.
  # It will be converted to a Ruby hash in #to_ruby
  def initialize(location = nil)
    unless location.nil?
      @location = location
      f = File.open(@location, 'r')
      @file = f.read
      f.close
    end

    yield(self) if block_given?
  end

  # Convert the file to a Ruby hash.
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

  # Here we actually write the new config file
  # to config/config.yml
  def write(args)
    File.open(args[:destination], 'w') do |f|
      f.write(args[:file])
      f.close
    end
  end

  # All this method does is handle retrieving
  # the file from config/config.yml
  # so that it can pass it off to Questioner,
  # which can in turn change the Hash and pass it
  # *back* to Configure, which can then choose
  # to actually write the file
  # to config/config.yml
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
