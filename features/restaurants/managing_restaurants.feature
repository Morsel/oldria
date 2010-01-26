@manage
Feature: Managing Restaurants
  So that I can manage my restaurants

  Background:
    Given the following confirmed users:
      | username | password |
      | joemsak  | secret   |
    And I am logged in as "joemsak" with password "secret"
    And I have just created a restaurant named "Jimmy's Diner"

  Scenario: I can view my restaurants individually
    Given I am on the dashboard
    When I follow "Jimmy's Diner"
    Then I should not see "Your Digital Dashboard"

  Scenario: I can edit the employees of restaurants I manage
    Given I am on the dashboard
    When I follow "Jimmy's Diner"
    And I follow "Manage employees"
    Then I should see "Employees at Jimmy's Diner"

  Scenario: I cannot edit the employees of restaurants I do not manage
    Given a restaurant named "Avec" with the following employees:
      | username | password | email            | name      | role      |
      | mgmt     | secret   | mgmt@example.com | Mgmt Joe  | Manager   |
      | bob      | secret   | bob@example.com  | Chef Bob  | Chef      |
    And I am logged in as "bob" with password "secret"
    When I follow "Avec"
    Then I should not see "Manage employees"

  Scenario: I can edit the restaurants I manage
    Given I am on the dashboard
    When I follow "Jimmy's Diner"
    And I follow "Edit restaurant"
    Then I should see "Editing Restaurant"