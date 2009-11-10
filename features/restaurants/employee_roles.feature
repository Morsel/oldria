@restaurant
Feature: Employee roles
  So that the right people get the right kinds of media requests, etc
  As a Restaurant point person
  I want to assign employment "Roles" to each of the people associated with my Restaurant.

  Background:
    Given the following confirmed users:
      | username | email               | name        | password |
      | mgmt     | manager@example.com | Jim Jones   | secret   |
      | betty    | betty@example.com   | Betty Davis | secret   |
      | cole     | cole@example.com    | Cole Cal    | secret   |
    Given I am logged in as "mgmt" with password "secret"
    And I have just created a restaurant named "Restaurant du Jour"
    And I have added "betty@example.com" to that restaurant
    And I have added "cole@example.com" to that restaurant

  Scenario: Basic Role Assignment
    Given a restaurant role named "Chef"
    Given I am on the employees page for "Restaurant du Jour"
    When I follow the edit role link for "Betty Davis"
    And I select "Chef" from "Restaurant role"
    And I press "Submit"
    Then I should see "updated"
    And "Betty Davis" should be a "Chef" at "Restaurant du Jour"


