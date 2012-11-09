Feature: git finish

  In order to finish the card for the current topic branch you can issue the following 
  commands:
  
    git finish 
    git finish <options>

  Supported options:
    -k <api_key>    - specify the Pivotal API key to use. Overrides configuration.
    -p <project_id> - specify the Pivotal project id to use. Overrides configuration.
    
  This will do the following:
    * switch to the master branch
    * delete the local branch
    * delete the remote branch
    * mark the card as finished in Pivotal

  Background:
    Given I have a started Pivotal Tracker feature
    And I am on the "CURRENT_CARD-feature" branch

  Scenario: Executing with no settings
    When I run `git-finish --force`
    Then the output should contain each line:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1

  Scenario: Executing with inline settings
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT --force`
    Then the output should contain each line:
      """
      Switching to master
      Destroying local branch
      Destroying remote branch
      Marking Story CURRENT_CARD as finished...
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
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT --force`
    Then the output should contain each line:
      """
      Switching to master
      Destroying local branch
      Destroying remote branch
      Marking Story CURRENT_CARD as finished...
      """
    And I should be on the "master" branch

  Scenario: Executing from a misnamed branch
    Given I am on the "missing-an-id" branch
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT --force`
    Then the output should contain each line:
      """
      Branch name must contain a Pivotal Tracker story id
      """
    And the exit status should be 1

  Scenario: Closing chore stories
    Given I have a started Pivotal Tracker chore
    And I am on the "CURRENT_CARD-chore" branch
    And a file named ".gitconfig" with:
      """
      [pivotal]
        api-token = PIVOTAL_API_KEY
        full-name = PIVOTAL_USER
        project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT --force`
    Then the output should contain each line:
      """
      Switching to master
      Destroying local branch
      Destroying remote branch
      Marking Story CURRENT_CARD as finished...
      """
    And I should be on the "master" branch
  
