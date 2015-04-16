# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ngi/version'

Gem::Specification.new do |spec|
  spec.name          = "ngi"
  spec.version       = Ngi::VERSION
  spec.authors       = ["Joshua Beam"]
  spec.email         = ["frontendcollisionblog@gmail.com"]
  spec.summary       = "Speed up AngularJS development by creating templates for all your components from the command line."
  spec.description   = %q{This tool can make (for example) an AngularJS controller template file for you (.js), so that whenever you want to make a new controller for your app, you don't have to type the same starting code over and over again (by the way, this tool doesn't only create controllers. It does directives, filters... almost anything). ngi has one task, and one task only, which makes it lightweight and specialized. Most AngularJS developers are probably using the command line already (Gulp, Bower, npm, Git, etc.), so why not use the command line to streamline your code-writing too? Type less, write more AngularJS!}
  spec.homepage      = "https://github.com/joshbeam/angular_init"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.1"

  spec.files         = `git ls-files -z`.split("\x0") - %w(.gitignore ngi_example.gif pkg README.md TUTORIAL.md COMMANDS.md)
  spec.executables   = ["ngi"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "memfs"
end
