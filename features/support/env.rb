$:.unshift('lib') unless $:.include?('lib')

require 'aruba'
require 'aruba/cucumber'
require 'git-pivotal'
require 'tracker_api'