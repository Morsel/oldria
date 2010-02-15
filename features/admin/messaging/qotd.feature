@admin @messaging
Feature: Admin Messaging: Question of the Day
  So that I can gain information from members
  As an RIA Staff member
  I want to send a QOTD through the Media Request Search Engine (MRSE) to associated restaurant folks

  Background:
    Given a restaurant named "Eight Ball" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    And there are no QOTDs in the system
    And I am logged in as an admin


  Scenario: Create a new QOTD
    Given I am on the new QOTD page
    When I perform the search:
      | Restaurant Name    | Eight Ball |
      | Role at Restaurant | Chef       |
    Then I should see "Sam Smith"
    But I should not see "John Doe"

    When I check "Sam Smith (Eight Ball)"
    And I fill in "Message" with "What is your favorite pie?"
    And I press "Save"
    Then I should see list of QOTDs
    And I should see "What is your favorite pie?"
    And "sam" should have 1 QOTD message

