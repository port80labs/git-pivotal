Feature: git chore

  In order to start the next available chore in the project you can issue the following
  commands:
     
     git chore
     git chore -D 
     git chore -k <api_key> -p <project_id>
     
  This will check out a topic branch for the chore and place you on it.
  
  Background:
    Given I have a Pivotal Tracker chore

  Scenario: Executing with no settings
    When I run `git-chore`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1

  Scenario: Starting the next chore interactively (without -D option)
    Given I have configured the Git repos for Pivotal
    When I run `git-chore` interactively
    And I type "a_really_bad_chore"
    Then the output should contain "Switched to a new branch 'CURRENT_CHORE-a_really_bad_chore'"
    And I should be on the "CURRENT_CHORE-a_really_bad_chore" branch
    And card CURRENT_CHORE is marked is started in Pivotal Tracker

  Scenario: Starting the next chore using configured defaults (with -D option)
    Given I have configured the Git repos for Pivotal
    When I run `git-chore -D`
    Then the output should contain "Switched to a new branch 'CURRENT_CHORE-chore'"
    And I should be on the "CURRENT_CHORE-chore" branch
    And card CURRENT_CHORE is marked is started in Pivotal Tracker

  Scenario: Starting the next chore with explicit command line arguments
    When I run `git-chore -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT -D`
    Then the output should contain "Switched to a new branch 'CURRENT_CHORE-chore'"
    And I should be on the "CURRENT_CHORE-chore" branch
    And card CURRENT_CHORE is marked is started in Pivotal Tracker

    