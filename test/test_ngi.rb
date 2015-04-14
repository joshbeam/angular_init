require_relative '../lib/ngi'
require 'minitest/autorun'
require 'memfs'

describe Ngi do
  before do
    MemFs.activate!
    @dir = File.dirname(__FILE__)

    @components_file = "#{@dir}/config/config.components.yml"
    @components_hash = Ngi::Delegate::Configure
                       .new(@components_file)
                       .to_ruby(from: 'yaml')

    @config_file = "#{@dir}/config/config.yml"
    @config_hash = Ngi::Delegate::Configure
                   .new(@config_file).to_ruby(from: 'yaml')

    # Open this up to redefine some stuff
    module Ngi
      # This mocks the user input for creating a new component
      MOCKED_ATTRS = [
        'test.directive.js',
        'myModule',
        'myDirective',
        ['someService, anotherService']
      ]
      class Delegate
        class Generator
          # Redefine the $stdin in Generator
          class AcceptInput
            def self.str(type)
              case type
              when :condensed
                MOCKED_ATTRS.shift
              when :comma_delimited_to_array
                MOCKED_ATTRS.shift
              when :downcased
                MOCKED_ATTRS.shift
              end
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
  end

  after { MemFs.deactivate! }

  describe 'Generator' do
    it 'should make a template for the given component' do
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
  end
end
