# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

# Utilities
module Utils
  # Current directory
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
