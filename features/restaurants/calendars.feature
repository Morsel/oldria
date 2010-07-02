@restaurant @calendar
Feature: a restaurant has a calendar with events
  Background:
  Given a restaurant named "Joe's Diner" with the following employees:
    | username | password | email            | name      | role      |
    | mgmt     | secret   | mgmt@example.com | Mgmt Joe  | Manager   |
    | sam      | secret   | sam@example.com  | Sam Smith | Chef      |
  And I am logged in as "mgmt"

  Scenario: a restaurant employee adds a new event
    Given I go to the new event page for "Joe's Diner"
    And I fill in "Title" with "Happy hour"
    And I select "Promotion" from "Calendar"
    And I fill in "Location" with "the bar"
    # And I select "July 18, 2010 04:00PM" as the "Start Date" date and time
    When I press "Save"
    Then I should be on the calendars page for "Joe's Diner"
    And I should see "Happy hour"
    
  Scenario: a restaurant employee tries to add an invalid event
    Given I go to the new event page for "Joe's Diner"
    When I press "Save"
    Then I should see "Title*can't be blank"
