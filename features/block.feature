Feature: git block

  In order to get information about a specific card you can issue one of the following 
  commands:

    git block
    git block <options>
    git block <card_id>
    git block <card_id> <options>

  Supported options:
    -m <message>    - specify the reason why this is blocked. If not present, will be prompted. Adds this message to the comment as an activity.
    -k <api_key>    - specify the Pivotal API key to use. Overrides configuration.
    -p <project_id> - specify the Pivotal project id to use. Overrides configuration.
    
  Background:
    Given I have a Pivotal Tracker feature named "Test Story" with description "This is the description!"
    And I am on the "CURRENT_CARD-feature" branch

  Scenario: Executing with no settings
    When I run `git-block`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
    
  Scenario: Blocking the current topic branch with a message argument
    Given I have configured the Git repos for Pivotal
    When I run `git-block -m "We need more information"`
    Then the output should contain "Story CURRENT_CARD has been blocked."
    When the current card is refreshed
    Then the card CURRENT_CARD should have the "blocked" label
    And the card CURRENT_CARD should have the comment by "PIVOTAL_USER":
      """
      We need more information
      """

  Scenario: Blocking the current topic branch and being prompted for a message
    Given I have configured the Git repos for Pivotal
    When I run `git-block` interactively
    When I type "We need more information"
    Then the output should contain "Story CURRENT_CARD has been blocked."
    When the current card is refreshed
    Then the card CURRENT_CARD should have the "blocked" label
    And the card CURRENT_CARD should have the comment by "PIVOTAL_USER":
      """
      We need more information
      """

  Scenario: Blocking a specific card with a message argument
    Given I have configured the Git repos for Pivotal
    When I run `git-block CURRENT_CARD -m "We need more information"`
    Then the output should contain "Story CURRENT_CARD has been blocked."
    When the current card is refreshed
    Then the card CURRENT_CARD should have the "blocked" label
    And the card CURRENT_CARD should have the comment by "PIVOTAL_USER":
      """
      We need more information
      """

  Scenario: Blocking a specific card and being prompted for a message
    Given I have configured the Git repos for Pivotal
    When I run `git-block CURRENT_CARD` interactively
    When I type "We need more information"
    Then the output should contain "Story CURRENT_CARD has been blocked."
    When the current card is refreshed
    Then the card CURRENT_CARD should have the "blocked" label
    And the card CURRENT_CARD should have the comment by "PIVOTAL_USER":
      """
      We need more information
      """

  Scenario: Blocking a card that is already blocked
    Given I have configured the Git repos for Pivotal
    And the card is labeled "blocked"
    When I run `git-block CURRENT_CARD -m "We need more information"`
    Then the output should contain "Story CURRENT_CARD is already blocked."
    When the current card is refreshed
    Then the card CURRENT_CARD should not have the comment:
      """
      We need more information
      """

  Scenario: Trying to block when not on a topic branch and not supplying a card id
    Given I have configured the Git repos for Pivotal
    And I am on the "foo" branch
    Then I should be on the "foo" branch
    When I run `git-block -m "this will fail"`
    Then the output should contain:
      """
      No story id was supplied and you aren't on a topic branch!
      """
  
    