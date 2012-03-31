Feature: git info

  Background:
    Given I have a Pivotal Tracker feature named "Test Story" with description "This is the description!"
    And I am on the "CURRENT_CARD-feature" branch

  Scenario: Executing with no settings
    When I run `git-info`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
    
  Scenario: Executing with inline options
    When I run `git-info -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT -D`
    Then the output should contain:
      """
      Story:         Test Story
      URL:           http://www.pivotaltracker.com/story/show/CURRENT_CARD
      Description:   This is the description!
      """

  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = PIVOTAL_API_KEY
              full-name = PIVOTAL_USER
              integration-branch = develop
              project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-info`
    Then the output should contain:
      """
      Story:         Test Story
      URL:           http://www.pivotaltracker.com/story/show/CURRENT_CARD
      Description:   This is the description!
      """
