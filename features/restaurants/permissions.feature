@restaurant
Feature: Restaurant Permissions
  In order to prevent accidental assignments or "firings" of employees
  As a Restaurant account manager
  I want to be the only employee that can edit employment information at the Restaurant

  Background:
    Given a restaurant named "Crazy Eights" with the following employees:
      | username | password | email            | name      | role      |
      | mgmt     | secret   | mgmt@example.com | Mgmt Joe  | Manager   |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      |
      | john     | secret   | john@example.com | John Doe  | Sommelier |
    And "mgmt" is the account manager for "Crazy Eights"

  Scenario Outline: Only manager can see "Add Employee" and edit buttons
    Given I am logged in as "<username>" with password "secret"
    Then I cannot go to the employees page for "Crazy Eights"