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

          # Abstracted template directory
          class TemplateDir
            attr_reader :d
            def initialize(component)
              @d = "#{@dir}/templates/"
              @d << "#{component['type']}/#{component['language']}"
              @d << "/#{component['using']}/#{component['template']}"
            end

            def read
              f = File.open(@d)
              content = f.read
              f.close

              content
            end
          end
        end

        class Configure
          # Redefine the $stdin in Generator
          class AcceptInput
            def self.str(type)
              case type
              when :stripped
                ConfigureMockedInput.input.shift
              end
            end
          end

          # Redefine this abstracted class
          class TemplateDir
            attr_reader :d

            def initialize(component, language, template)
              @d = "#{@dir}/templates/"
              @d << "#{component['type']}/#{language}"
              @d << "/user/#{template}"
            end
          end

        end

      end
    end

    # Expected file output
    @finished_files = {
      'directive' => IO.read("#{@dir}/finished_files/directive.finished.js"),
      'controller' => IO.read("#{@dir}/finished_files/controller.finished.js"),
      'filter' => IO.read("#{@dir}/finished_files/filter.finished.js")
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

    def check_generated_content(type, file, comparison)
      # Now we're going to "create" a new directive using the default template
      Ngi::GeneratorMockedInput.input = @generator_mocked_input[type]
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
        puts content
        puts comparison
        assert content == comparison
        f.close
      end
      ##########################
    end

    # Make this directory in memory using MemFs (won't
    # actually create this directory in the file system)
    FileUtils.mkdir_p('templates/script/es5/default')

    # Make the default template in memory from the actual one using IO.read
    # since MemFs doesn't use IO (it only uses File)
    # This will just save me from having to write the whole template
    # out as a string inside a variable right here...
    dir_str = 'templates/script/es5/default/basic.js'
    File.open(dir_str, 'w') do |f|
      f.write(IO.read("#{@dir}/templates/script/es5/default/basic.js"))
      f.close
    end
    #########################################################
  end

  after { MemFs.deactivate! }

  describe 'Generator' do
    describe 'Default Templates' do
      it 'should make a directive' do
        type = 'directive'
        check_generated_content(
          type, 'test.directive.js', @finished_files[type].gsub(/\s/, '')
        )
      end

      it 'should make a controller' do
        type = 'controller'
        check_generated_content(
          type, 'test.controller.js', @finished_files[type].gsub(/\s/, '')
        )
      end

      it 'should make a filter' do
        type = 'filter'
        check_generated_content(
          type, 'test.filter.js', @finished_files[type].gsub(/\s/, '')
        )
      end
    end

    it 'should use the custom template if one was set' do
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

      type = 'directive'
      check_generated_content(type, 'test.directive.js', 'hellomyDirective')
    end
  end
end
