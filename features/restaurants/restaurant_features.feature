Feature: Associate Restaurant features
  In order to Asscociate tags to a restaurant
  As a restaurant manager
  I want to manage restaurant tags

  Background:
    Given I am logged in as an admin
    And a restaurant named "Piece"
    And the following restaurant features:
      | page    | category      | value    |
      | Cuisine | Cuisine Style | Casual   |
      | Cuisine | Cuisine       | Buffet   |
      | Cuisine | Cuisine type  | Armenian |
      | Design  | Decor         | Ugly     |

  Scenario: Initial navigation
    When I go to the restaurant show page for "Piece"
    And I follow "Edit restaurant features"
    Then I am on the restaurant feature page for "Piece"
    And I see the page headers
    And I see the category headers
    And I see the category values

  Scenario: Selecting a checkbox should persist
    When I go to the restaurant feature page for "Piece"
    And I check "Casual"
    And I check "Ugly"
    And I press "Update all features"
    Then the "Casual" checkbox should be checked
    And the "Ugly" checkbox should be checked
    And the "Buffet" checkbox should not be checked

# Scenario: Selecting a checkbox should display the page and tag on the home page

