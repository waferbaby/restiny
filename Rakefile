# frozen_string_literal: true

desc 'Build the gem'
task :build do
  sh 'gem build restiny.gemspec'
end

desc 'Publish the gem to rubygems.org'
task :publish do
  require_relative 'lib/restiny/version'

  version = Restiny::VERSION
  filename = "restiny-#{version}.gem"

  sh "gem push #{filename}"
  sh "rm #{filename}"
end
