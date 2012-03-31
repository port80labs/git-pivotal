require 'fileutils'
require 'pry'

PIVOTAL_API_KEY = "80f3c308cfdfbaa8f5a21aa524081690"
PIVOTAL_TEST_PROJECT = 516377
PIVOTAL_TEST_STORY = 27322725
PIVOTAL_USER = "Robotic Zach"

Before do
  @aruba_timeout_seconds = 5
  build_temp_paths
  set_env_variables
end

After do
  # The features seem to have trouble repeating accurately without
  # setting the test story to an unstarted feature for the next run.
  delete_created_cards 
  update_test_story("feature", :current_state => "unstarted")
end

def build_temp_paths
  _mkdir(current_dir)

  test_repo = File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_repo'))
  FileUtils.cp_r(test_repo, current_dir)
  Dir.chdir(File.join(current_dir, 'test_repo')) do
    FileUtils.mv('working.git', '.git')
  end
end

def set_env_variables
  set_env "GIT_DIR", File.expand_path(File.join(current_dir, 'test_repo', '.git'))
  set_env "GIT_WORK_TREE", File.expand_path(File.join(current_dir, 'test_repo'))
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
