Feature: git block

  In order to get information about a specific card you can issue one of the following 
  commands:

    git unblock
    git unblock <options>
    git unblock <card_id>
    git unblock <card_id> <options>

  Supported options:
    -k <api_key>    - specify the Pivotal API key to use. Overrides configuration.
    -p <project_id> - specify the Pivotal project id to use. Overrides configuration.
    
  Background:
    Given I have a Pivotal Tracker feature named "Test Story" with description "This is the description!"
    And I am on the "CURRENT_CARD-feature" branch

  # This scenario is to test the presence of a bug in Pivotal Tracker's v3 API. It is 
  # impossible to remove the last label from a story. When this fails then git-unblock
  # will need to be updated to not use a placeholder label.
  Scenario: Is Pivotal's API for removing the last label on a card still broken?
    Given I have configured the Git repos for Pivotal
    And the card is labeled "blocked"
    When I run `git-unblock`
    Then the card CURRENT_CARD should have the "blocked" label

  Scenario: Executing with no settings
    When I run `git-unblock`
    Then the output should contain each line:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
    
  Scenario: Unblocking the current topic branch
    Given I have configured the Git repos for Pivotal
    And the card is labeled "blocked"
    When I run `git-unblock`
    Then the output should contain "Story CURRENT_CARD has been unblocked."
    When the current card is refreshed
    Then the card CURRENT_CARD should not have the "blocked" label

  Scenario: Unlocking a specific card
    Given I have configured the Git repos for Pivotal
    And the card is labeled "blocked"
    When I run `git-unblock CURRENT_CARD`
    Then the output should contain "Story CURRENT_CARD has been unblocked."
    When the current card is refreshed
    Then the card CURRENT_CARD should not have the "blocked" label

  Scenario: Unblocking a card that is not blocked
    Given I have configured the Git repos for Pivotal
    When I run `git-unblock CURRENT_CARD`
    Then the output should contain "Story CURRENT_CARD is already unblocked."
    When the current card is refreshed
    Then the card CURRENT_CARD should not have the "blocked" label

  Scenario: Trying to unblock when not on a topic branch and not supplying a card id
    Given I have configured the Git repos for Pivotal
    And I am on the "foo" branch
    Then I should be on the "foo" branch
    When I run `git-unblock`
    Then the output should contain each line:
      """
      No story id was supplied and you aren't on a topic branch!
      """
  