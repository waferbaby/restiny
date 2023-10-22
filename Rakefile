# frozen_string_literal: true

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = Dir['spec/**/*.rb']
end

task default: :spec

task :build do
  Rake::Task['cleanup'].invoke
  `gem build restiny.gemspec`
end

task :publish do
  `gem push restiny*.gem`
  Rake::Task['cleanup'].invoke
end

task :cleanup do
  FileUtils.rm(Dir['restiny*.gem'])
end
