# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitchen/driver/lxd_api_version'

Gem::Specification.new do |spec|
  spec.name          = 'kitchen-lxd_api'
  spec.version       = Kitchen::Driver::LXD_API_VERSION
  spec.authors       = ['inokappa']
  spec.email         = ['inokara at gmail.com']
  spec.description   = %q{A Test Kitchen Driver for LxdApi}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/inokappa/kitchen-lxd_api'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'test-kitchen'
  spec.add_dependency 'oreno_lxdapi'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"

  #spec.add_development_dependency 'cane'
  #spec.add_development_dependency 'tailor'
  #spec.add_development_dependency 'countloc'
end
