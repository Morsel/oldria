@restaurant_menus
Feature: Restaurant Menus
  In order to find information about a restaurant's menus,
  I as a public user,
  would like to see the restaurant menus

  Background:
    Given I am logged in as an admin
    And a restaurant named "Bourgeois Pig"

    @wip
  Scenario: Upload a menu
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I fill in "January" for "Name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_attachment"
    And I press "Upload"
    Then I see the uploaded restaurant menu

