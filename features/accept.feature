Feature: git accept

  In order to accept a card the following commands:
  
    git accept 
    git accept <options>

  Supported options:
    -k <api_key>    - specify the Pivotal API key to use. Overrides configuration.
    -p <project_id> - specify the Pivotal project id to use. Overrides configuration.
    
  This will do the following:
    * mark the card as accepted in Pivotal
    * push the topic branch to origin
    * switch to main integration branch, run git pull, then merge in topic branch
    * push main integration branch
    * (TODO) delete topic branch is everything previously was done cleanly

  Related git configuration settings:
    * pivotal.integration-branch - this is where accepted cards are merged. Defaults to master.

  Background:
    Given I have a finished Pivotal Tracker feature
    And I am on the "CURRENT_CARD-feature" branch

  Scenario: Executing with no settings
    When I run `git-accept`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1

  Scenario: Executing with inline settings
    When I run `git-accept -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Marking Story CURRENT_CARD as accepted...
      Pushing CURRENT_CARD-feature to origin
      Pulling master...
      Merging CURRENT_CARD-feature into master
      Pushing master to origin
      Now on master.
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
    When I run `git-accept -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Marking Story CURRENT_CARD as accepted...
      Pushing CURRENT_CARD-feature to origin
      Pulling master...
      Merging CURRENT_CARD-feature into master
      Pushing master to origin
      Now on master.
      """
    And I should be on the "master" branch

  Scenario: Executing from a misnamed branch
    Given I am on the "missing-an-id" branch
    When I run `git-accept -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Branch name must contain a Pivotal Tracker story id
      """
    And the exit status should be 1

  Scenario: Specifying an integration branch in Git configuration
    Given I have a "release" branch
    And a file named ".gitconfig" with:
      """
      [pivotal]
        api-token = PIVOTAL_API_KEY
        full-name = PIVOTAL_USER
        integration-branch = release
        project-id = PIVOTAL_TEST_PROJECT
      """
    When I run `git-accept -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Marking Story CURRENT_CARD as accepted...
      Pushing CURRENT_CARD-feature to origin
      Pulling release...
      Merging CURRENT_CARD-feature into release
      Pushing release to origin
      Now on release.
      """
    And I should be on the "release" branch

  Scenario Outline: Accepting cards in an acceptable state
    Given I have configured the Git repos for Pivotal
    And the card is a <card_type>
    And the <card_type> is <card_state>
    When I run `git-accept -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Marking Story CURRENT_CARD as accepted...
      Pushing CURRENT_CARD-feature to origin
      Pulling master...
      Merging CURRENT_CARD-feature into master
      Pushing master to origin
      Now on master.
      """
    And I should be on the "master" branch
    
    Examples:
      | card_type | card_state |
      | chore     | accepted   |
      | bug       | finished   |
      | bug       | delivered  |
      | feature   | finished   |
      | feature   | delivered  |
  
  Scenario Outline: You can't accept cards that aren't ready to be accepted
    Given I have configured the Git repos for Pivotal
    And the card is a <card_type>
    And the <card_type> is <card_state>
    When I run `git-accept -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT`
    Then the output should contain:
      """
      Story is not in an acceptable state. It's currently <card_state>.
      """
    And I should be on the "CURRENT_CARD-feature" branch

    Examples:
      | card_type | card_state |
      | bug       | unstarted  |
      | bug       | started    |
      | chore     | unstarted  |
      | feature   | unstarted  |
      | feature   | started    |
      | feature   | rejected   |
