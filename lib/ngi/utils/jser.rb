# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# Utilities
module Utils
  # Since ngi is an AngularJS tool and the users
  # are familiar with JavaScript, this module of classes
  # prints a string version of a Ruby hash or array
  # as it would appear in normal JavaScript syntax
  # For example:
  # { "hello" => "world" }
  # becomes:
  # { 'hello': 'world' }.
  module JSer
    def to_str
      to_s.gsub(/\"/, "'").gsub(/\=\>/, ': ')
    end

    # Usage: JSHash.new({"hello" => "world"}).to_str
    class JSHash < Hash
      def initialize(hash)
        super
        hash.each do |key, val|
          self[key] = val
        end
      end

      include JSer
    end

    # Usage: JSArray.new(["some","array"]).to_str
    class JSArray < Array
      def initialize(array)
        super
      end

      include JSer
    end

    module_function

    # This makes the module JSer "look like"
    # a class that can be "newed", even though
    # JSer is a module. When we "new" JSer,
    # it delegates flow of control
    # to either JSArray or JSHash, depending
    # on what type of object is passed in.
    def new(obj)
      if obj.class == Array
        return JSArray.new(obj)
      elsif obj.class == Hash
        return JSHash.new(obj)
      end
    end
  end
end
