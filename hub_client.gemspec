# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hub_client/version'

Gem::Specification.new do |spec|
  spec.name          = "hub_client"
  spec.version       = HubClient::VERSION
  spec.authors       = ["Mariano Abel Coca"]
  spec.email         = ["marianoabelcoca@gmail.com"]
  spec.summary       = %q{Hub Client allows connecting your application with Instedd's Hub}
  spec.description   = %q{Use Hub}
  spec.homepage      = "https://bitbucket.org/instedd/ruby-hub_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
