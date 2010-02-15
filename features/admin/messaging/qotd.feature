@admin @messaging
Feature: Admin Messaging: Question of the Day
  So that I can gain information from members
  As an RIA Staff member
  I want to send a QOTD through the Media Request Search Engine (MRSE) to associated restaurant folks

  # Background:
  #   Given I am logged in as an admin


  Scenario: Create a new QOTD
    Given there are no QOTDs in the system
    Given I am logged in as an admin
    When I create a new QOTD with:
      | Message | What is your favorite pie? |
    Then I should see list of QOTDs
    And I should see "What is your favorite pie?"

