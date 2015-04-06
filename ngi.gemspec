# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ngi/version'

Gem::Specification.new do |spec|
  spec.name          = "ngi"
  spec.version       = Ngi::VERSION
  spec.authors       = ["Joshua Beam"]
  spec.email         = ["joshua.a.beam@gmail.com"]
  spec.summary       = "Speed up AngularJS development by creating templates for all your components from the command line."
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  # spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["ngi"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
