@restaurant
Feature: Employee Subject Matter Assignments
  So that the right kinds of requests go to the right people
  As a Restaurant Account Manager
  I want to assign subject matters to one or many of my Restaurant's employees


  Background:
    Given a subject matter "Beverages"
    Given the following confirmed users:
      | username | email               | name        | password |
      | mgmt     | manager@example.com | Jim Jones   | secret   |
      | betty    | dodo@example.com    | Dodo DaVeer | secret   |
    Given I am logged in as "mgmt" with password "secret"


  Scenario: Basic Assignment
    Given I have just created a restaurant named "Restaurant du Jour"
    And I have added "dodo@example.com" to that restaurant
    And I am on the employees page for "Restaurant du Jour"
    When I follow the edit role link for "Dodo DaVeer"
    Then I should see "Editing Employee Dodo DaVeer"

    When I check "Beverages"
    And I press "Submit"
    Then I should see "updated"
    And "Dodo DaVeer" should be responsible for "Beverages" at "Restaurant du Jour"
