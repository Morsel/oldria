@restaurant @management
Feature: Managing Restaurants
  So that I can manage my restaurants

  Background:
    Given the following confirmed users:
      | username | password | email           |
      | joemsak  | secret   | joe@sample.com  |
      | jane     | secreter | jane@sample.com |
    And I am logged in as "joemsak" with password "secret"
    And I have just created a restaurant named "Jimmy's Diner"

  Scenario: I can view my restaurants individually
    Given I am on the dashboard
    When I follow "Edit Restaurant"
    And I follow "Jimmy's Diner"
    Then I should not see "Your Digital Dashboard"

  Scenario: I can edit the employees of restaurants I manage
    Given I am on the dashboard
    When I follow "Edit Restaurant"
    And I follow "Edit Jimmy's Diner"
    And I follow "Staff"
    Then I should see "Rearrange the order employees are listed on your restaurant"

  Scenario: I can add restaurant managers
    Given I have added "jane@sample.com" to that restaurant
    When I follow "edit"
    And I check "employment_omniscient"
    And I press "Submit"
    Then I should see "Account Administrator"

  Scenario: I cannot edit the employees of restaurants I do not manage
    Given a restaurant named "Avec" with the following employees:
      | username | password | email            | name      | role      |
      | mgmt     | secret   | mgmt@example.com | Mgmt Joe  | Manager   |
      | bob      | secret   | bob@example.com  | Chef Bob  | Chef      |
    And I am logged in as "bob" with password "secret"
    When I follow "Edit Restaurant"
    And I follow "Avec"
    Then I should not see "Manage employees"

  Scenario: I can edit the restaurants I manage
    Given I am on the dashboard
    When I follow "Edit Restaurant"
    And I follow "Edit Jimmy's Diner"
    Then I should see "Back to public view"