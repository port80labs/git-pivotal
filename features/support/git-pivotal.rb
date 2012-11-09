require 'fileutils'
require 'pry'

PIVOTAL_API_KEY = ENV['PIVOTAL_API_KEY']
PIVOTAL_TEST_PROJECT = ENV['PIVOTAL_TEST_PROJECT']
PIVOTAL_USER = ENV['PIVOTAL_USER']

Before do
  @aruba_io_wait_seconds = 1
  @aruba_timeout_seconds = 60
  build_temp_paths
  set_env_variables
end

After do
  # The features seem to have trouble repeating accurately without
  # setting the test story to an unstarted feature for the next run.
  delete_created_cards 
end

at_exit do
  FileUtils.rm_r "tmp/aruba"
  FileUtils.rm_r "tmp/origin.git"
end

def build_temp_paths
  dir = File.expand_path(File.dirname(__FILE__))
  test_repo = File.expand_path(File.join(dir, '..', 'test_repo'))
  tmp = File.expand_path(File.join(dir, '..', '..', 'tmp'))
  
  FileUtils.cp_r "#{test_repo}/origin.git", "#{tmp}/origin.git"
  `git clone #{tmp}/origin.git #{current_dir}/working.git`
  
  Dir.chdir(current_dir + "/working.git") do
    system "git branch -D acceptance > /dev/null 2>&1"
    system "git branch acceptance master > /dev/null 2>&1"
  end
end

def set_env_variables
  set_env "GIT_DIR", File.expand_path(File.join(current_dir, 'working.git', '.git'))
  set_env "GIT_WORK_TREE", File.expand_path(File.join(current_dir, 'working.git'))
  set_env "HOME", File.expand_path(current_dir)
end


def current_branch
  `git symbolic-ref HEAD`.chomp.split('/').last
end

module RSpec
  module Expectations
    module DifferAsStringAcceptsArrays
      def self.included(klass)
        klass.class_eval do
          alias_method :original_diff_as_string, :diff_as_string
          define_method :diff_as_string do |data_new, data_old|
            data_old = data_old.join if data_old.respond_to?(:join)
            data_new = data_new.join if data_new.respond_to?(:join)
            original_diff_as_string data_new, data_old
          end
        end
      end
    end
      
    Differ.send :include, DifferAsStringAcceptsArrays
  end
end
