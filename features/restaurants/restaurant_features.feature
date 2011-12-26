@restaurant
Feature: Associate Restaurant features
  In order to Associate tags to a restaurant
  As a restaurant manager
  I want to manage restaurant tags

  Background:
    Given I am logged in as an admin
    And a restaurant named "Piece"
    And that "Piece" has a premium account
    And the following restaurant features:
      | page    | category      | value    |
      | Cuisine | Cuisine Style | Casual   |
      | Cuisine | Cuisine       | Buffet   |
      | Cuisine | Cuisine type  | Armenian |
      | Design  | Decor         | Ugly     |

  Scenario: Initial navigation
    When I go to the restaurant show page for "Piece"
    And I follow "Edit restaurant" within "#restaurant_actions"
    And I follow "Features" within "#edit_resto_menu"
    Then I am on the restaurant feature page for "Piece"
    And I see the page header for "Cuisine"
    And I see the category headers for "Cuisine"
    And I see the category values for "Cuisine"

  Scenario: Selecting a checkbox should persist
    When I go to the restaurant feature page for "Piece"
    And I check "Casual"
    And I check "Buffet"
    And I press "Update all features"
    Then the "Casual" checkbox should be checked
    And the "Buffet" checkbox should be checked
    And the "Armenian" checkbox should not be checked

  Scenario: Selecting a checkbox should display the page and tag on the home page
    When I go to the restaurant feature page for "Piece"
    And I check "Casual"
    And I check "Buffet"
    And I press "Update all features"
    And I go to the soapbox restaurant profile for "Piece"
    Then I see a navigation link for "Cuisine"
    And I do not see a navigation link for "Design"

  Scenario: Clicking on the detail link takes you to the interior page
    When I go to the restaurant feature page for "Piece"
    And I check "Casual"
    And I check "Buffet"
    And I press "Update all features"
    And I go to the soapbox restaurant profile for "Piece"
    And I follow "Cuisine"
    Then I am on the soapbox restaurant feature page for "Piece" and "Cuisine"
    And I see headers for feature categories for "Cuisine"
    And I see "Cuisine" links for "Buffet"
    And I see "Cuisine Style" links for "Casual"
    And I do not see links for "Armenian"

  Scenario: Clicking on a tag link takes you to a link page
    Given a restaurant named "Gino's East"
    And "Piece" is tagged with "Buffet, Casual"
    And "Gino's East" is tagged with "Buffet, Ugly"
    And I go to the soapbox restaurant profile for "Piece"
    And I follow "Cuisine"
    And I follow "Buffet"
    And I see the restaurant "Piece"
    And I see the restaurant "Gino's East"
