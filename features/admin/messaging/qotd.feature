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
    Given "john" is not allowed to post to soapbox
    And I am on the new QOTD page
    When I check "Eight Ball"
    And I fill in "Message" with "What is your favorite pie?"
    And I press "Submit"
    Then I should see list of QOTDs
    And I should see "What is your favorite pie?"
    And "sam" should have 1 QOTD message
    And "john" should have 0 QOTD messages

@emails
  Scenario: New QOTD notification, user prefers no emails
    Given "sam" prefers to not receive direct message alerts
    And I am on the new QOTD page
    When I check "Eight Ball"
    And I fill in "Message" with "What is your favorite cake?"
    And I press "Submit"
    Then "sam@example.com" should have no emails

@emails
  Scenario: New QOTD notification, user prefers emails
    Given "sam" prefers to receive direct message alerts
    And I am on the new QOTD page
    When I check "Eight Ball"
    And I fill in "Message" with "What is your favorite cookie?"
    And I press "Submit"
    Then "sam@example.com" should have 1 email

@emails
  Scenario: New QOTD notification, user has set an alternate notification email address
    Given "sam" prefers to receive direct message alerts
    And "sam" has set a notification email address "assistant@myrestaurant.com"
	And I am on the new QOTD page
	When I check "Eight Ball"
	And I fill in "Message" with "What is your favorite cookie?"
	And I press "Submit"
	Then "assistant@myrestaurant.com" should have 1 email
