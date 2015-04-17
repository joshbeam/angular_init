# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# Utilities
module Utils
  # Current directory. We use this
  # in place of a constant. When testing,
  # we can reset the CurrentDir to use
  # the testing config files (which are
  # separate from the normal config files)
  # and suppress any CONSTANT REDEFINITION
  # errors. 
  class CurrentDir
    @@dir = ''

    def self.dir=(dir)
      @@dir = dir
    end

    def self.dir
      @@dir
    end
  end
end
