# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fail_retry/version'

Gem::Specification.new do |spec|
  spec.name          = "fail_retry"
  spec.version       = FailRetry::VERSION
  spec.authors       = ["Tomoya Hirano"]
  spec.email         = ["hiranotomoya@gmail.com"]
  spec.summary       = %q{Make method retryable}
  spec.homepage      = "http://github.com/tomoya55/fail_retry"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.1"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.10.0"
end
