@restaurant
Feature: Signup restaurant
  So that I can get my restaurant up on RIA
  As a SpoonFeed user
  I want to sign up a Restaurant with: Name, Location (all fields), and Simple Facts
  And I want to be the administrative contact of that Restaurant


  Scenario: Sign up a new restaurant
    Given the following confirmed users:
      | username | password |
      | joesak   | secret   |
    And the following metropolitan_area records:
      | name            |
      | Chicago IL      |
      | Indianapolis IN |
    And the following cuisine records:
      | name     |
      | American |
      | Italian  |
    Given I am logged in as "joesak" with password "secret"
    And I am on the new restaurant page
    When I fill in "Restaurant Name" with "Joe's Shack"
    And I fill in "City" with "Chicago"
    And I select "Chicago IL" from "Metropolitan area"
    And I select "Italian" from "Cuisine"
    And I press "Submit"
    Then I should see "Successfully created restaurant"
    And "joesak" should be the account manager for "Joe's Shack"
    And "Joe's Shack" should be in the "Chicago IL" metropolitan area
    And "Joe's Shack" should have "Italian" cuisine
    And I should see "Joe's Shack" within "My Restaurants" section
