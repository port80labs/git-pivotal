Feature: git finish

  Background:
    Given I have a started Pivotal Tracker feature
    And I am on the "27322725-feature" branch

  Scenario: Executing with no settings
    When I run `git-finish`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1

  Scenario: Excuting with inline settings
    When I run `git-finish -k 80f3c308cfdfbaa8f5a21aa524081690 -p 516377`
    Then the output should contain:
      """
      Marking Story 27322725 as finished...
      Merging 27322725-feature into master
      Removing 27322725-feature branch
      """
    And I should be on the "master" branch

  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 80f3c308cfdfbaa8f5a21aa524081690
              full-name = Robotic Zach
              project-id = 516377
      """
    When I run `git-finish -k 80f3c308cfdfbaa8f5a21aa524081690 -p 516377`
    Then the output should contain:
      """
      Marking Story 27322725 as finished...
      Merging 27322725-feature into master
      Removing 27322725-feature branch
      """
    And I should be on the "master" branch

  Scenario: Executing from a misnamed branch
    Given I am on the "missing-an-id" branch
    When I run `git-finish -k 80f3c308cfdfbaa8f5a21aa524081690 -p 516377`
    Then the output should contain:
      """
      Branch name must contain a Pivotal Tracker story id
      """
    And the exit status should be 1

  Scenario: Specifying an integration branch
    Given I have a "develop" branch
    And a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 80f3c308cfdfbaa8f5a21aa524081690
              full-name = Robotic Zach
              integration-branch = develop
              project-id = 516377
      """
    When I run `git-finish -k 80f3c308cfdfbaa8f5a21aa524081690 -p 516377`
    Then the output should contain:
      """
      Marking Story 27322725 as finished...
      Merging 27322725-feature into develop
      Removing 27322725-feature branch
      """
    And I should be on the "develop" branch

  Scenario: Closing chore stories
    Given I have a started Pivotal Tracker chore
    And I am on the "27322725-chore" branch
    And a file named ".gitconfig" with:
      """
      [pivotal]
              api-token = 80f3c308cfdfbaa8f5a21aa524081690
              full-name = Robotic Zach
              project-id = 516377
      """
    When I run `git-finish -k 80f3c308cfdfbaa8f5a21aa524081690 -p 516377`
    Then the output should contain:
      """
      Marking Story 27322725 as finished...
      Merging 27322725-chore into master
      Removing 27322725-chore branch
      """
    And I should be on the "master" branch
  
