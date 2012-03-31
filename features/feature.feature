Feature: git feature

  In order to start the next available feature in the project you can issue the following
  commands:
     
     git feature
     git feature -D 
     git feature -k <api_key> -p <project_id>
     
  This will check out a topic branch for the feature and place you on it.
  
  Background:
    Given I have a Pivotal Tracker feature

  Scenario: Executing with no settings
    When I run `git-feature`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
    
  Scenario: Executing when there are no estimated features to start
    Given I have configured the Git repos for Pivotal
    And the feature is unestimated
    When I run `git-feature -D`
    Then the output should contain:
      """
      Stories in the started state must be estimated.
      """
    And the exit status should be 1

  Scenario: Starting the next feature interactively (without -D option)
    Given I have configured the Git repos for Pivotal
    When I run `git-feature` interactively
    And I type "a_really_great_feature"
    Then the output should contain "Switched to a new branch 'CURRENT_FEATURE-a_really_great_feature'"
    And I should be on the "CURRENT_FEATURE-a_really_great_feature" branch
    And card CURRENT_FEATURE is marked is started in Pivotal Tracker

  Scenario: Starting the next feature using configured defaults (with -D option)
    Given I have configured the Git repos for Pivotal
    When I run `git-feature -D`
    Then the output should contain "Switched to a new branch 'CURRENT_FEATURE-feature'"
    And I should be on the "CURRENT_FEATURE-feature" branch
    And card CURRENT_FEATURE is marked is started in Pivotal Tracker

  Scenario: Starting the next feature with explicit command line arguments
    When I run `git-feature -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT -D`
    Then the output should contain "Switched to a new branch 'CURRENT_FEATURE-feature'"
    And I should be on the "CURRENT_FEATURE-feature" branch
    And card CURRENT_FEATURE is marked is started in Pivotal Tracker
