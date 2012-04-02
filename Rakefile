require 'rubygems'
require 'rake'

$LOAD_PATH.unshift('lib')

task :default => [:spec, :features]

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = ['--color']
  end
rescue LoadError => e
  puts "RSpec not installed"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty"
  end
rescue LoadError => e
  puts "Cucumber not installed"
end
