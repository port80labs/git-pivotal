Feature: git bug

  In order to start the next available bug in the project you can issue the following
  commands:
     
     git bug
     git bug -D 
     git bug -k <api_key> -p <project_id>
     
  This will check out a topic branch for the bug and place you on it.
  
  Background:
    Given I have a Pivotal Tracker bug

  Scenario: Starting the next bug interactively (without -D option)
    Given I have configured the Git repos for Pivotal
    When I run `git-bug` interactively
    And I type "a_really_bad_bug"
    Then the output should contain "Switched to a new branch 'CURRENT_BUG-a_really_bad_bug'"
    And I should be on the "CURRENT_BUG-a_really_bad_bug" branch
    And card CURRENT_BUG is marked is started in Pivotal Tracker

  Scenario: Starting the next bug using configured defaults (with -D option)
    Given I have configured the Git repos for Pivotal
    When I run `git-bug -D`
    Then the output should contain "Switched to a new branch 'CURRENT_BUG-bugfix'"
    And I should be on the "CURRENT_BUG-bugfix" branch
    And card CURRENT_BUG is marked is started in Pivotal Tracker

  Scenario: Starting the next bug with explicit command line arguments
    When I run `git-bug -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT -D`
    Then the output should contain "Switched to a new branch 'CURRENT_BUG-bugfix'"
    And I should be on the "CURRENT_BUG-bugfix" branch
    And card CURRENT_BUG is marked is started in Pivotal Tracker
