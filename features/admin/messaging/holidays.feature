@admin @messaging
Feature: Holidays
In order to remind restauranteurs about upcoming events
As an RIA staff member
I want to set up holidays, with multiple scheduled reminders

  Background:
    Given a restaurant named "Eight Ball" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    And I am logged in as an admin


  Scenario: Create a new Holiday (not displayed on their own)
    Given I am on the new holiday page
    When I perform the search:
      | Restaurant Name    | Eight Ball |
      | Role at Restaurant | Chef       |
    Then I should see "Sam Smith"
    But I should not see "John Doe"

    When I check "Sam Smith (Eight Ball)"
    And I fill in "Name" with "Easter"
    And I press "Save"
    Then I should see list of Holidays
    And I should see "Easter"
    And "sam" should be subscribed to the holiday "Easter"

    Given I am logged in as "sam" with password "secret"
    When I go to my inbox
    Then I should not see "Easter"

@focus
  Scenario: Replying to a Holiday Reminder
    Given a holiday exists named "Christmas" and recipients:
      | email           |
      | sam@example.com |
    When I create a new reminder for holiday "Christmas" with:
      | Scheduled at | 2009-01-01 12:00:00                |
      | Message      | Don't forget to wrap your presents |
    Then "sam" should be subscribed to the holiday "Christmas"

    Given I am logged in as "sam" with password "secret"
    When I go to my inbox
    Then I should see "Christmas"
    When I follow "Reply"
    And I fill in "Reply" with "Here it is"
    And I press "Send"
    Then I should see "Successfully created"

    Given I am logged in as "john" with password "secret"
    When I go to my inbox
    Then I should not see "Christmas"

