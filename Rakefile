require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core/rake_task'

desc 'Build Gem'
task :build do
  system 'gem build improvmx.gemspec'
end

desc 'Run tests'
RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = %w[--colour]
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new
