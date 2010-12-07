@admin @messaging @holidays
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

  Scenario: Create a new Holiday
    Given I am on the new holiday page
    When I create a holiday with name "Easter" and criteria:
      | Restaurant | Eight Ball |
    Then I should see list of Holidays
    And I should see "Easter"
    And "sam" should be subscribed to the holiday "Easter"

    Given I am logged in as "sam" with password "secret"
    When I go to my inbox
    Then I should not see "Easter"

  Scenario: Replying to a Holiday Reminder
    When I create a holiday with name "Christmas" and criteria:
      | Restaurant | Eight Ball |
      | Role       | Chef       |
    When I create a new reminder for holiday "Christmas" with:
      | Scheduled at | 2009-01-01 12:00:00                |
      | Message      | Don't forget to wrap your presents |
    Then the last holiday for "Eight Ball" should be viewable by "Sam Smith"
    And the last holiday for "Eight Ball" should not be viewable by "John Doe"

@emails
  Scenario: New Holiday Reminder notification, user prefers no emails
  Given "sam" prefers to not receive direct message alerts
  When I create a holiday with name "Christmas" and criteria:
    | Restaurant | Eight Ball |
  When I create a new reminder for holiday "Christmas" with:
    | Scheduled at | 2009-01-01 12:00:00                |
    | Message      | Don't forget to wrap your presents |
  Then "sam@example.com" should have no emails

@emails
  Scenario: New Holiday Reminder notification, user prefers emails
  Given "sam" prefers to receive direct message alerts
  When I create a holiday with name "Christmas" and criteria:
    | Restaurant | Eight Ball |
  When I create a new reminder for holiday "Christmas" with:
    | Scheduled at | 2009-01-01 12:00:00                |
    | Message      | Don't forget to wrap your presents |
  Then "sam@example.com" should have 1 email
