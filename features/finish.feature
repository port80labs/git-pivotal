Feature: git finish

  In order to finish the card for the current topic branch you can issue the following 
  commands:
  
    git finish 
    git finish <options>

  Supported options:
    -k <api_key>    - specify the Pivotal API key to use. Overrides configuration.
    -p <project_id> - specify the Pivotal project id to use. Overrides configuration.
    
  This will do the following:
    * mark the card as finished in Pivotal
    * push the topic branch to origin
    * switch to 'acceptance' integration branch, run git pull, then merge in topic branch
    * push 'acceptance' integration branch

  Related git configuration settings:
    * pivotal.acceptance-branch - this is where finished cards are merged. Defaults to acceptance.

  Background:
    Given I have a started Pivotal Tracker feature
    And I am on the "CURRENT_CARD-feature" branch

  Scenario: Executing with no settings
    When I run `git-finish`
    Then the output should contain each line:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1

  Scenario: Executing with inline settings
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain each line:
      """
      Marking Story CURRENT_CARD as finished...
      Pushing CURRENT_CARD-feature to origin
      Pulling acceptance...
      Merging CURRENT_CARD-feature into acceptance
      Pushing acceptance to origin
      Now on acceptance.
      """
    And I should be on the "acceptance" branch

  Scenario: Executing with git configuration
    Given a file named ".gitconfig" with:
      """
      [pivotal]
        api-token = PIVOTAL_API_KEY
        full-name = PIVOTAL_USER
        project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain each line:
      """
      Marking Story CURRENT_CARD as finished...
      Pushing CURRENT_CARD-feature to origin
      Pulling acceptance...
      Merging CURRENT_CARD-feature into acceptance
      Pushing acceptance to origin
      Now on acceptance.
      """
    And I should be on the "acceptance" branch

  Scenario: Executing from a misnamed branch
    Given I am on the "missing-an-id" branch
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain each line:
      """
      Branch name must contain a Pivotal Tracker story id
      """
    And the exit status should be 1

  Scenario: Specifying an integration branch in Git configuration
    Given I have a "develop" branch
    And a file named ".gitconfig" with:
      """
      [pivotal]
        api-token = PIVOTAL_API_KEY
        full-name = PIVOTAL_USER
        acceptance-branch = develop
        project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain each line:
      """
      Marking Story CURRENT_CARD as finished...
      Pushing CURRENT_CARD-feature to origin
      Pulling develop...
      Merging CURRENT_CARD-feature into develop
      Pushing develop to origin
      Now on develop.
      """
    And I should be on the "develop" branch

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
    When I run `git-finish -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain each line:
      """
      Marking Story CURRENT_CARD as finished...
      Pushing CURRENT_CARD-chore to origin
      Pulling acceptance...
      Merging CURRENT_CARD-chore into acceptance
      Pushing acceptance to origin
      Now on acceptance.
      """
    And I should be on the "acceptance" branch
  
