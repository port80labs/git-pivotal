Feature: General Git Pivotal story-picking features

  Background:
    Given I have a Pivotal Tracker feature
    And a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = PIVOTAL_API_KEY
              full-name = PIVOTAL_USER
              integration-branch = develop
              project-id = PIVOTAL_TEST_PROJECT
      """

  Scenario: Giving better error messaging
    Given the feature is unestimated
    When I run `git-feature -D`
    Then the output should contain:
      """
      Stories in the started state must be estimated.
      """
    And the exit status should be 1
