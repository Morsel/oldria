@restaurant_menus
Feature: Restaurant Menus
  In order to find information about a restaurant's menus,
  I as a public user,
  would like to see the restaurant menus

  Background:
    Given I am logged in as an admin
    And a restaurant named "Bourgeois Pig"
    And the date and time is "now"

  Scenario: Upload a menu
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I fill in "January" for "Name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_attachment"
    And I press "Upload"
    Then I should see a menu with the name "January" and change frequency "Monthly" and uploaded at date "now" 
    Then I should see a link to download the uploaded menu pdf "menu1.pdf"

  Scenario: Delete a menu
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I fill in "January" for "Name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_attachment"
    And I press "Upload"
    Then I should have a menu with the name "January" and change frequency "Monthly"
    When I delete the menu with the name "January"
    Then I should not have a menu with the name "January" and change frequency "Monthly"

