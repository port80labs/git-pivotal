require 'rubygems'
require 'rake'

$LOAD_PATH.unshift('lib')

task :default => [:spec, :features]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "git-pivotal-tracker"
    gemspec.summary = "A collection of git utilities to ease integration with Pivotal Tracker."
    gemspec.description = "A collection of git utilities to ease integration with Pivotal Tracker."
    gemspec.email = "zach.dennis@gmail.com"
    gemspec.homepage = "http://github.com/zdennis/git-pivotal"
    gemspec.authors = ["Zach Dennis", "Jeff Tucker", "Sam Stokes"]
    gemspec.post_install_message = <<-EOT.gsub(/^\s+\S/, '')
      |If you haven't set up git-pivotal-tracker before, here's a few commands to 
      |get started:
      |
      |   # Applies to global Git configuration
      |   git config --global pivotal.api-token <your-token-here>
      |   git config --global pivotal.full-name "Your Name As In Pivotal"
      |
      |   # Applies to project-specific Git configuration
      |   git config -f .git/config pivotal.project-id <pivotal-project-id>
      |
    EOT
    
    gemspec.add_dependency "builder"
    gemspec.add_dependency "pivotal-tracker", "~>0.5.1"
    
    gemspec.add_development_dependency "pry"
    gemspec.add_development_dependency "rspec"
    gemspec.add_development_dependency "cucumber"
    gemspec.add_development_dependency "aruba"
  end
  
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler not available. Install it with: gem install jeweler"
end

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
