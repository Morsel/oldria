@restaurant
Feature: Signup restaurant
  So that I can get my restaurant up on RIA
  As a SpoonFeed user
  I want to sign up a Restaurant with: Name, Location (all fields), and Simple Facts
  And I want to be the administrative contact of that Restaurant

  Background:
    Given the following confirmed users:
      | username | password |
      | joesak   | secret   |
    And the following metropolitan_area records:
      | name         | state    |
      | Chicago      | Illinois |
      | Indianapolis | Indiana  |
    And the following cuisine records:
      | name     |
      | American |
      | Italian  |
	And "joesak" has a default employment with role "Chef" and restaurant name "Joe's Shack"

  Scenario: Sign up a new restaurant
    Given I am logged in as "joesak" with password "secret"
    And I am on the new restaurant page

    When I fill in "Restaurant name" with "Joe's Shack"
    And I fill in "Street address" with "566 W. Adams"
    And I fill in "City" with "Chicago"
    And I fill in "State" with "IL"
    And I fill in "Zip" with "12345"
    And I fill in "Phone number" with "123-4567"
    And I fill in "Website" with "http://www.website.com"
    And I select "Illinois: Chicago" from "Metropolitan area"
    And I select "Italian" from "Cuisine"
    When I select "2008-01-22" as the "Opening date" date
    And I press "Submit"

    Then I should see "Successfully created restaurant"
    And "joesak" should be the account manager for "Joe's Shack"
    And "Joe's Shack" should be in the "Chicago" metropolitan area
    And "Joe's Shack" should have "Italian" cuisine
    And "joesak" should not have a default employment
    
    When I follow "edit my restaurant"
    Then I should see "Joe's Shack"
