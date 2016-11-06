$:.unshift('lib') unless $:.include?('lib')

require 'aruba'
require 'aruba/cucumber'
require 'git-pivotal-tracker'
require 'pivotal-tracker'