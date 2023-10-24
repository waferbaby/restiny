# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('./lib')

require 'restiny/version'

Gem::Specification.new do |s|
  s.name = 'restiny'
  s.version = Restiny::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Daniel Bogan']
  s.email = ['d+restiny@waferbaby.com']
  s.homepage = 'http://github.com/waferbaby/restiny'
  s.summary = 'A Destiny API gem'
  s.description = "A gem for interacting with Bungie's Destiny API."
  s.license = 'MIT'

  s.required_ruby_version = '> 3.0'

  s.files = Dir['lib/**/*']
  s.require_path = 'lib'

  s.add_runtime_dependency 'down', '~> 5.4'
  s.add_runtime_dependency 'faraday', '~> 2.0'
  s.add_runtime_dependency 'faraday-follow_redirects', '~> 0.3'
  s.add_runtime_dependency 'rubyzip', '~> 2.3'
  s.add_runtime_dependency 'sqlite3', '~> 1.3'

  s.metadata['rubygems_mfa_required'] = 'true'
end
