Feature: General Git Pivotal story-picking features

  Background:
    Given I have a Pivotal Tracker feature
    And a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 80f3c308cfdfbaa8f5a21aa524081690
              full-name = Robotic Zach
              integration-branch = develop
              project-id = 516377
      """

  Scenario: Giving better error messaging
    Given the feature is unestimated
    When I run `git-feature -D`
    Then the output should contain:
      """
      Stories in the started state must be estimated.
      """
    And the exit status should be 1
