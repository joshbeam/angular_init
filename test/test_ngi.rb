require_relative '../lib/ngi'
require 'minitest/autorun'
require 'memfs'

describe Ngi do
  before do
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
      # This mocks the user input for creating a new component
      GENERATOR_MOCKED_ATTRS = [
        'test.directive.js',
        'myModule',
        'myDirective',
        ['someService, anotherService']
      ]

      CONFIGURE_MOCKED_INPUT = [
        'templates',
        'directive',
        'test.template.js',
        'es5'
      ]
      class Delegate

        class Generator
          # Redefine the $stdin in Generator
          class AcceptInput
            def self.str(type)
              case type
              when :condensed
                GENERATOR_MOCKED_ATTRS.shift
              when :comma_delimited_to_array
                GENERATOR_MOCKED_ATTRS.shift
              when :downcased
                GENERATOR_MOCKED_ATTRS.shift
              end
            end
          end

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
                CONFIGURE_MOCKED_INPUT.shift
              end
            end
          end

          class TemplateDir
            attr_reader :d

            def initialize(component, language, template)
              @d = "#{@dir}/templates/"
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

        end

      end
    end

    # Expected file output
    @finished_file = ";(function(app) {

  'use strict';

  app.directive('myDirective',myDirective);

  myDirective.$inject = ['someService, anotherService'];

  function myDirective(someService, anotherService) {

    var d = {
      restrict: 'A',
      link: link
    };

    return d;

    function link(scope, element, attrs) {

    }


  }

})(angular.module('myModule'));".gsub(/\s/, '')

    MemFs.activate!
  end

  after { MemFs.deactivate! }

  describe 'Generator' do
    it 'should make a template for the given component' do
      Dir.mkdir('templates')
      Dir.mkdir('templates/script')
      Dir.mkdir('templates/script/es5')
      Dir.mkdir('templates/script/es5/default')

      # Make the default template in memory from the actual one using IO.read
      # since MemFs doesn't use IO (it only uses File)
      dir_str = 'templates/script/es5/default/basic.js'
      File.open(dir_str, 'w') do |f|
        f.write(IO.read("#{@dir}/templates/script/es5/default/basic.js"))
        f.close
      end

      type = 'directive'

      chosen_type = -> (c) { c['name'] == type }
      component = @components_hash.find(&chosen_type)

      Ngi::Delegate::Generator.run(
        type: type,
        config: @config_hash,
        component: component
      )

      File.exist?('test.directive.js').must_equal true

      File.open('test.directive.js', 'r') do |f|
        assert f.read.to_s.gsub(/\s/, '') == @finished_file
        f.close
      end
    end

    it 'should use the custom template if one was set' do
      File.open('test.template.js', 'w') do |f|
        f.write('hello {{name}}')
        f.close
      end

      Dir.mkdir('test')
      Dir.mkdir('test/config')

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

      chosen_type = -> (c) { c['name'] == type }
      component = @components_hash.find(&chosen_type)

      config_hash = Ngi::Delegate::Configure
                    .new('test/config/config.yml')
                    .to_ruby(from: 'yaml')

      if config_hash.key? 'templates'
        custom = config_hash['templates'].find(&chosen_type)
        language = config_hash['language'].collect { |_, v| v }

        unless custom.nil?
          template = custom['templates']
                     .find { |t| language.include? t['language'] }

          unless template.nil?
            template = template['template']
            # Rebuild the object to be used by Delegate::Generator
            custom = {
              'type' => custom['type'],
              'using' => 'user',
              'template' => template,
              'name' => custom['name']
            }

            component = custom
          end
        end
      end

      Ngi::Delegate::Generator.run(
        type: type,
        config: config_hash,
        component: component
      )

      File.open('test.directive.js', 'r') do |f|
        content = f.read
        f.close

        assert content == 'hello myDirective'
      end

    end
  end
end
