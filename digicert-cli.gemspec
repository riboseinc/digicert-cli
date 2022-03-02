# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "digicert/cli/version"

Gem::Specification.new do |spec|
  spec.name          = "digicert-cli"
  spec.version       = Digicert::CLI::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["operations@ribose.com"]

  spec.summary       = %q{The CLI for digicert API}
  spec.description   = %q{The CLI for digicert API}
  spec.homepage      = "https://www.ribose.com"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {spec}/*`.split("\n")

  spec.require_paths = ["lib"]
  spec.bindir        = "bin"
  spec.executables   = "digicert"

  spec.add_dependency "thor", "~> 0.19.4"
  spec.add_dependency "digicert", "~> 1.0"
  spec.add_dependency "openssl", ">= 2.0.3"
  spec.add_dependency "terminal-table"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.11.3"
end
