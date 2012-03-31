Feature: git start

  In order to start the next available card in the project you can issue the following
  commands:
     
     git start <options>
     git start <card_type> <options>

  Supported options:
    -k <api_key>    - specify the Pivotal API key to use. Overrides configuration.
    -p <project_id> - specify the Pivotal project id to use. Overrides configuration.
    -D              - do not prompt for user input, use recommended values by default.
    
  This will check out a topic branch for the card and place you on it.
  
  Scenario Outline: Executing with no settings
    When I run `<command>`
    Then the output should contain:
      """
      Pivotal Tracker API Token and Project ID are required
      """
    And the exit status should be 1
  
    Examples:
      | command     |
      | git-bug     |
      | git-chore   |
      | git-feature |

  Scenario: Starting the next feature when it is unestimated
    Given I have an unestimated Pivotal Tracker feature
    And I have configured the Git repos for Pivotal
    When I run `git-feature -D`
    Then the output should contain:
      """
      Stories in the started state must be estimated.
      """
    And the exit status should be 1

  # Assumption: that chores can be started without being estimated in Pivotal
  Scenario: Starting the next chore when it is unestimated
    Given I have an unestimated Pivotal Tracker chore
    And I have configured the Git repos for Pivotal
    When I run `git-chore -D`
    Then the output should contain "Switched to a new branch 'CURRENT_CHORE-chore'"
    And I should be on the "CURRENT_CHORE-chore" branch
    And card CURRENT_CHORE is marked is started in Pivotal Tracker

  # Assumption: that estimating bugs in Pivotal is turned off
  Scenario: Starting the next bug when it is unestimated
    Given I have an unestimated Pivotal Tracker bug
    And I have configured the Git repos for Pivotal
    When I run `git-bug -D`
    Then the output should contain "Switched to a new branch 'CURRENT_CARD-bugfix'"
    And I should be on the "CURRENT_CARD-bugfix" branch
    And card CURRENT_BUG is marked is started in Pivotal Tracker

  Scenario Outline: Starting the next estimated card interactively (without -D option)
    Given I have a Pivotal Tracker <card_type>
    And I have configured the Git repos for Pivotal
    When I run `git-<card_type>` interactively
    And I type "a_purple_<card_type>"
    Then the output should contain "Switched to a new branch 'CURRENT_CARD-a_purple_<card_type>'"
    And I should be on the "CURRENT_CARD-a_purple_<card_type>" branch
    And card CURRENT_BUG is marked is started in Pivotal Tracker
    
    Examples:
      | card_type |
      | bug       |
      | chore     |
      | feature   |

  Scenario Outline: Starting the next estimated card using configured defaults (with -D option)
    Given I have a Pivotal Tracker <card_type>
    And I have configured the Git repos for Pivotal
    When I run `git-<card_type> -D`
    Then the output should contain "Switched to a new branch 'CURRENT_CARD-<card_type><branch_suffix>'"
    And I should be on the "CURRENT_CARD-<card_type><branch_suffix>" branch
    And card CURRENT_CARD is marked is started in Pivotal Tracker
    
    Examples:
      | card_type | branch_suffix |
      | bug       |     fix       |
      | chore     |               |
      | feature   |               |

  Scenario Outline: Supplying Pivotal configuration via command line arguments
    Given I have a Pivotal Tracker <card_type>
    And I have configured the Git repos for Pivotal with bogus information
    When I run `git-<card_type> -k PIVOTAL_API_KEY -p PIVOTAL_TEST_PROJECT -n "PIVOTAL_USER" -D`
    Then the output should contain "Switched to a new branch 'CURRENT_CARD-<card_type><branch_suffix>'"
    And I should be on the "CURRENT_CARD-<card_type><branch_suffix>" branch
    And card CURRENT_CARD is marked is started in Pivotal Tracker

    Examples:
      | card_type | branch_suffix |
      | bug       |     fix       |
      | chore     |               |
      | feature   |               |
