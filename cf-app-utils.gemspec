# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'cf-app-utils'
  spec.version       = '0.3'
  spec.authors       = ['Cloud Foundry']
  spec.email         = %w(vcap-dev@cloudfoundry.org)
  spec.description   = %q{Helper methods for apps running on Cloud Foundry}
  spec.summary       = %q{Helper methods for apps running on Cloud Foundry}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*'] + ['LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
