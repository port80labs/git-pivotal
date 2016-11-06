# -*- encoding: utf-8 -*-  
$:.push File.expand_path("../lib", __FILE__)  
  
Gem::Specification.new do |s|  
  s.name          = "git-pivotal"
  s.version       = IO.read("VERSION")
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Zach Dennis", "Jeff Tucker", "Sam Stokes", "John Wood"]
  s.email         = "john@johnpwood.net"
  s.homepage      = "https://github.com/port80labs/git-pivotal"
  s.summary       = "A collection of git utilities to ease integration with Pivotal Tracker."
  s.description   = "A collection of git utilities to ease integration with Pivotal Tracker."
  
  s.files         = `git ls-files`.split("\n")  
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<pivotal-tracker>, [">= 0"])

  s.add_development_dependency(%q<rake>, [">= 0"])
  s.add_development_dependency(%q<mocha>, [">= 0"])
  s.add_development_dependency(%q<simplecov>, [">= 0"])
  s.add_development_dependency(%q<aruba>, [">= 0"])
  s.add_development_dependency(%q<rspec>, [">= 0"])
  s.add_development_dependency(%q<cucumber>, [">= 0"])
  s.add_development_dependency(%q<pry>, [">= 0"])
end

