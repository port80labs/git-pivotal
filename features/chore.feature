  Feature: git chore

  Background:
    Given I have a Pivotal Tracker chore

  Scenario: Executing with inline options
    When I run `git-chore -k 80f3c308cfdfbaa8f5a21aa524081690 -p 516377 -D`
    Then the output should contain "Switched to a new branch '27322725-chore'"
    And I should be on the "27322725-chore" branch
    
  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 80f3c308cfdfbaa8f5a21aa524081690
              full-name = Robotic Zach
              integration-branch = develop
              project-id = 516377
      """
    When I run `git-chore -D`
    Then the output should contain "Switched to a new branch '27322725-chore'"
    And I should be on the "27322725-chore" branch  