Feature: git finish

  Background:
    Given I have a started Pivotal Tracker feature
    And I am on the "CURRENT_FEATURE-feature" branch

  Scenario: Executing with no settings
    When I run `git-finish`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1

  Scenario: Executing with inline settings
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Marking Story CURRENT_FEATURE as finished...
      Merging CURRENT_FEATURE-feature into master
      Removing CURRENT_FEATURE-feature branch
      """
    And I should be on the "master" branch

  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
        api-token = PIVOTAL_API_KEY
        full-name = PIVOTAL_USER
        project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Marking Story CURRENT_FEATURE as finished...
      Merging CURRENT_FEATURE-feature into master
      Removing CURRENT_FEATURE-feature branch
      """
    And I should be on the "master" branch

  Scenario: Executing from a misnamed branch
    Given I am on the "missing-an-id" branch
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
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
        api-token = PIVOTAL_API_KEY
        full-name = PIVOTAL_USER
        integration-branch = develop
        project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Marking Story CURRENT_FEATURE as finished...
      Merging CURRENT_FEATURE-feature into develop
      Removing CURRENT_FEATURE-feature branch
      """
    And I should be on the "develop" branch

  Scenario: Closing chore stories
    Given I have a started Pivotal Tracker chore
    And I am on the "CURRENT_FEATURE-chore" branch
    And a file named ".gitconfig" with:
      """
      [pivotal]
        api-token = PIVOTAL_API_KEY
        full-name = PIVOTAL_USER
        project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Marking Story CURRENT_FEATURE as finished...
      Merging CURRENT_FEATURE-chore into master
      Removing CURRENT_FEATURE-chore branch
      """
    And I should be on the "master" branch
  
