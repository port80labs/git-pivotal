require 'rubygems'
require 'rake'

$LOAD_PATH.unshift('lib')

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "git-pivotal"
    gemspec.summary = "A collection of git utilities to ease integration with Pivotal Tracker"
    gemspec.description = "A collection of git utilities to ease integration with Pivotal Tracker"
    gemspec.email = "jeff@trydionel.com"
    gemspec.homepage = "http://github.com/trydionel/git-pivotal"
    gemspec.authors = ["Jeff Tucker", "Sam Stokes"]
  end
  
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler not available. Install it with: gem install jeweler"
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = ['--color']
    t.rcov = true
    t.rcov_opts = ['--exclude', 'gems']
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


task :default => [:spec, :features]