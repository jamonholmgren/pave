# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pave/version"

Gem::Specification.new do |spec|
  spec.name          = "pave"
  spec.version       = Pave::VERSION
  spec.authors       = ["Jamon Holmgren", "Ryan Linton"]
  spec.email         = ["jamon@clearsightstudio.com", "ryanl@clearsightstudio.com"]
  spec.description   = %q{Provides a set of command line tools for Concrete5.}
  spec.summary       = %q{Provides a set of command line tools for Concrete5.}
  spec.homepage      = "https://github.com/jamonholmgren/pave"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency("bundler", "~> 1.3")
  spec.add_development_dependency("rdoc", "~> 4.1")
  spec.add_development_dependency("rake", "~> 10.1")
  spec.add_development_dependency("rspec", "~> 2")
  spec.add_dependency("commander", "~> 4.1")

  spec.required_ruby_version = '>= 1.9.3'
end
