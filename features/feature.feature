Feature: git feature

  Background:
    Given I have a Pivotal Tracker feature

  Scenario: Executing with no settings
    When I run `git-feature`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
  
  Scenario: Executing with inline options
    When I run `git-feature -k 80f3c308cfdfbaa8f5a21aa524081690 -p 516377 -D`
    Then the output should contain:
      """
      Retrieving latest features from Pivotal Tracker...
      Story: Test Story
      URL:   http://www.pivotaltracker.com/story/show/27322725
      Updating feature status in Pivotal Tracker...
      Switched to a new branch '27322725-feature'
      """
    And I should be on the "27322725-feature" branch

  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 80f3c308cfdfbaa8f5a21aa524081690
              full-name = Robotic Zach
              integration-branch = develop
              project-id = 516377
      """
    When I run `git-feature -D`
    Then the output should contain "Switched to a new branch '27322725-feature'"
    And I should be on the "27322725-feature" branch