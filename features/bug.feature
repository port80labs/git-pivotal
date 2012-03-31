Feature: git bug

  Background:
    Given I have a Pivotal Tracker bug

  Scenario: Verifying created branch
    When I run `git-bug -k 80f3c308cfdfbaa8f5a21aa524081690 -p 516377 -D`
    Then the output should contain "Switched to a new branch '27322725-bugfix'"
    And I should be on the "27322725-bugfix" branch