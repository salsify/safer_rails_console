# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'safer_rails_console/version'

Gem::Specification.new do |spec|
  spec.name          = 'safer_rails_console'
  spec.version       = SaferRailsConsole::VERSION
  spec.authors       = ['Salsify Engineering']
  spec.email         = ['engineering@salsify.com']

  spec.summary       = 'Make rails console less dangerous!'
  spec.description   = 'This gem makes console sessions less dangerous in specified environments by warning, color-coding, auto-sandboxing, and disabling external connections, job queueing, etc.'
  spec.homepage      = 'https://github.com/salsify/safer_rails_console'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://gems.salsify.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_runtime_dependency 'activesupport', '>=4', '<=5'
  spec.add_runtime_dependency 'rails', '>= 4', '<= 5'
end
