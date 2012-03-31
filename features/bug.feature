Feature: git bug

  In order to start the next available bug in the project you can issue the following
  commands:
     
     git bug
     git bug -D 
     git bug -k <api_key> -p <project_id>
     
  This will check out a topic branch for the bug and place you on it.
  
  Background:
    Given I have a Pivotal Tracker bug

  Scenario: Starting the next bug using configured defaults
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = PIVOTAL_API_KEY
              full-name = PIVOTAL_USER
              integration-branch = develop
              project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-bug -D`
    Then the output should contain "Switched to a new branch 'CURRENT_BUG-bugfix'"
    And I should be on the "CURRENT_BUG-bugfix" branch
    And card CURRENT_BUG is marked is started in Pivotal Tracker

  Scenario: Starting the next bug with explicit command line arguments
    When I run `git-bug -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT -D`
    Then the output should contain "Switched to a new branch 'CURRENT_BUG-bugfix'"
    And I should be on the "CURRENT_BUG-bugfix" branch
    And card CURRENT_BUG is marked is started in Pivotal Tracker
