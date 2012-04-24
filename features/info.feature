Feature: git info

  In order to get information about a specific card you can issue one of the following 
  commands:

    git info
    git info <options>
    git info <card_id>
    git info <card_id> <options>

  Supported options:
    --comments      - displays comments for the card
    -k <api_key>    - specify the Pivotal API key to use. Overrides configuration.
    -p <project_id> - specify the Pivotal project id to use. Overrides configuration.
    -D              - do not prompt for user input, use recommended values by default.
    
  Background:
    Given I have a Pivotal Tracker feature named "Test Story" with description "This is the description!"
    And I am on the "CURRENT_CARD-feature" branch

  Scenario: Executing with no settings
    When I run `git-info`
    Then the output should contain each line:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
    
  Scenario: Grabbing info about current topic branch
    Given I have configured the Git repos for Pivotal
    When I run `git-info`
    Then the output should contain each line:
      """
      Story:         Test Story
      URL:           http://www.pivotaltracker.com/story/show/CURRENT_CARD
      State:         not accepted
      Description:
        This is the description!
      """

  Scenario: Supplying Pivotal configuration via command line arguments
    When I run `git-info -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT -n "PIVOTAL_USER" -D`
    Then the output should contain each line:
      """
      Story:         Test Story
      URL:           http://www.pivotaltracker.com/story/show/CURRENT_CARD
      State:         not accepted
      Description:
        This is the description!
      """

  Scenario: Grabbing info about a specific card in question topic branch
    Given I have a Pivotal Tracker chore named "Test Chore" with description "The chore description!"
    And I have configured the Git repos for Pivotal
    When I run `git-info CURRENT_CARD`
    Then the output should contain each line:
      """
      Story:         Test Chore
      URL:           http://www.pivotaltracker.com/story/show/CURRENT_CARD
      State:         not accepted
      Description:
        The chore description!
      """

  Scenario: Grabbing info when the card has labels
    Given I have a Pivotal Tracker chore named "Test Chore" with description "The chore description!"
    And the chore is labeled "foo, bar, baz"
    And I have configured the Git repos for Pivotal
    When I run `git-info CURRENT_CARD`
    Then the output should contain each line:
      """
      Story:         Test Chore
      URL:           http://www.pivotaltracker.com/story/show/CURRENT_CARD
      Labels:        bar, baz, foo
      State:         not accepted
      Description:
        The chore description!
      """

  Scenario: Requesting comments on a card using --comments
    Given I have a Pivotal Tracker chore named "Test Chore" with description "The chore description!"
    And the "PIVOTAL_USER" commented on the card "Well, this looks mighty fine!"
    And I have configured the Git repos for Pivotal
    When I run `git-info CURRENT_CARD --comments`
    Then the output should contain "Comments:"
    And the output should contain "Well, this looks mighty fine!"
    And the output should contain "PIVOTAL_USER"

  Scenario: Grabbing info when not on a topic branch and not supplying a card id
    Given I have configured the Git repos for Pivotal
    And I am on the "foo" branch
    Then I should be on the "foo" branch
    When I run `git-info`
    Then the output should contain each line:
      """
      No story id was supplied and you aren't on a topic branch!
      """
  
  