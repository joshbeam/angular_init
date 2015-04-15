require_relative '../lib/ngi'
# require_relative 'testing_utils'
require 'minitest/autorun'
require 'memfs'

# Overwrite output so that we don't see it when testing
def puts(_)
  nil
end

def print(_)
  nil
end

describe Ngi do
  before do
    ############ SETUP ##############
    @dir = File.dirname(__FILE__)

    @components_file = "#{@dir}/config/config.components.yml"
    @components_hash = Ngi::Delegate::Configure
                       .new(@components_file)
                       .to_ruby(from: 'yaml')
    @components = @components_hash.collect { |c| c['name'] }

    @config_file = "#{@dir}/config/config.yml"
    @config_hash = Ngi::Delegate::Configure
                   .new(@config_file).to_ruby(from: 'yaml')

    @languages_file = "#{@dir}/config/config.languages.yml"
    @languages_hash = Ngi::Delegate::Configure
                      .new(@languages_file).to_ruby(from: 'yaml')

    @configurable_file = "#{@dir}/config/config.configurable.yml"
    @configurable = Ngi::Delegate::Configure
                    .new(@configurable_file).to_ruby(from: 'yaml')

    module Utils
      class CommandParser
        # Redefine the output so we can test it
        class Output
          def to_s
            @str
          end
        end
      end
    end

    # Open this up to redefine some stuff
    module Ngi
      # Be able to mock $stdin
      class MockedInput
        @@input = []

        def self.input=(input)
          @@input = input
        end

        def self.input
          return @@input
        end
      end

      class GeneratorMockedInput < MockedInput; end
      class ConfigureMockedInput < MockedInput; end

      class Delegate
        # Redefine some methods/classes
        class Generator
          Utils::CurrentDir.dir = @dir

          # Redefine the $stdin in Generator
          class AcceptInput
            def self.str(type)
              case type
              when :condensed
                GeneratorMockedInput.input.shift
              when :comma_delimited_to_array
                GeneratorMockedInput.input.shift
              when :downcased
                GeneratorMockedInput.input.shift
              end
            end
          end
        end

        # Redefine
        class Configure
          Utils::CurrentDir.dir = @dir

          # Redefine the $stdin in Generator
          class AcceptInput
            def self.str(type)
              case type
              when :stripped
                ConfigureMockedInput.input.shift
              end
            end
          end
        end
      end
    end

    # Expected file output
    @finished_files = {
      'directive' => {
        'es5' => IO.read("#{@dir}/finished_files/script/es5/directive.finished.js"),
        'coffee' => IO.read("#{@dir}/finished_files/script/coffee/directive.finished.coffee")
      },
      'controller' => {
        'es5' => IO.read("#{@dir}/finished_files/script/es5/controller.finished.js")
      },
      'filter' => {
        'es5' => IO.read("#{@dir}/finished_files/script/es5/filter.finished.js")
      }
    }

    @generator_mocked_input = {
      'directive' => [
        'test.directive.js',
        'myModule',
        'myDirective',
        %w(someService anotherService)
      ],
      'controller' => [
        'test.controller.js',
        'myModule',
        'MyController',
        %w(someService anotherService)
      ],
      'filter' => [
        'test.filter.js',
        'myModule',
        'someFilter',
        %w(aService andAnotherOne)
      ]
    }

    # Now we can activate MemFs so that we don't
    # actually create any files in the file system
    MemFs.activate!

    # Make this directory in memory using MemFs (won't
    # actually create this directory in the file system)
    FileUtils.mkdir_p('templates/script/es5/default')
    FileUtils.mkdir_p('templates/script/coffee/default')

    # Make the default template in memory from the actual one using IO.read
    # since MemFs doesn't use IO (it only uses File)
    # This will just save me from having to write the whole template
    # out as a string inside a variable right here...
    dir_str = 'templates/script/es5/default/basic.js'
    File.open(dir_str, 'w') do |f|
      f.write(IO.read("#{@dir}/templates/script/es5/default/basic.js"))
      f.close
    end

    dir_str = 'templates/script/coffee/default/basic.js'
    File.open(dir_str, 'w') do |f|
      f.write(IO.read("#{@dir}/templates/script/coffee/default/basic.js"))
      f.close
    end

    def check_generated_content(type, language, file, comparison)
      # Now we're going to "create" a new directive using the default template
      if Ngi::GeneratorMockedInput.input.size == 0
        Ngi::GeneratorMockedInput.input = @generator_mocked_input[type].dup
      end

      type = type
      component = Ngi::Parser::ComponentChooser
                  .new(
                    type: type,
                    components_hash: @components_hash,
                    config_hash: @config_hash
                  )
                  .component

      Ngi::Delegate::Generator.run(
        type: type,
        config: @config_hash,
        component: component
      )

      ###### ASSERTIONS ########
      # It should've created the directive
      File.exist?(file).must_equal true

      # The directive should match the expected output,
      # which is shown in @finished_file
      File.open(file, 'r') do |f|
        content = f.read.to_s.gsub(/\s/, '')
        assert content == comparison
        f.close
      end
      ##########################
    end
    #########################################################
  end

  after { MemFs.deactivate! }

  describe 'Parser' do
    describe '-v' do
      it 'should show the version of ngi' do
        assert Parser.parse(['-v']) == "ngi #{Ngi::VERSION}"
      end
    end
  end

  describe 'Generator' do
    describe 'Default Templates' do
      it 'should make a directive' do
        type = 'directive'
        language = 'es5'
        check_generated_content(
          type, language,
          'test.directive.js', @finished_files[type][language].gsub(/\s/, '')
        )
      end

      it 'should make a controller' do
        type = 'controller'
        language = 'es5'
        check_generated_content(
          type, language, 'test.controller.js',
          @finished_files[type][language].gsub(/\s/, '')
        )
      end

      it 'should make a filter' do
        type = 'filter'
        language = 'es5'
        check_generated_content(
          type, language,
          'test.filter.js', @finished_files[type][language].gsub(/\s/, '')
        )
      end
    end

    it 'should use the custom template if one was set for that language (and it should use the default for all other languages not set)' do
      # First we'll create our custom template in memory
      # using MemFs to mock it
      File.open('test.template.js', 'w') do |f|
        f.write('hello {{name}}')
        f.close
      end

      # Make this directory in memory with MemFs
      FileUtils.mkdir_p('test/config')

      Ngi::ConfigureMockedInput
        .input = %w(templates directive test.template.js es5)

      # We're going to configure ngi,
      # according to CONFIGURE_MOCKED_INPUT
      # It'll basically create a custom template
      # for use with es5
      Ngi::Delegate::Configure.run(
        write: true,
        to: 'yaml',
        destination: @config_file,
        languages: @languages_hash,
        config: @config_hash,
        components: @components,
        components_hash: @components_hash,
        configurable: @configurable
      )

      check_generated_content(
        'directive', 'es5',
        'test.directive.js', 'hellomyDirective'
      )

      # Change the language to coffee so we can
      # make sure that it will use the default
      # coffee template, since only the es5
      # custom template was set
      Ngi::ConfigureMockedInput
        .input = %w(language script coffee)

      Ngi::Delegate::Configure.run(
        write: true,
        to: 'yaml',
        destination: @config_file,
        languages: @languages_hash,
        config: @config_hash,
        components: @components,
        components_hash: @components_hash,
        configurable: @configurable
      )

      type = 'directive'
      language = 'coffee'
      Ngi::GeneratorMockedInput
        .input = [
          'second.test.directive.js',
          'myModule',
          'myDirective',
          %w(someService anotherService)
        ]
      check_generated_content(
        type, language,
        'second.test.directive.js',
        @finished_files[type][language].gsub(/\s/, '')
      )
    end
  end
end
