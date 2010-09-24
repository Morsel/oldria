Feature: Associate Restaurant features
  In order to Associate tags to a restaurant
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

  Scenario: Selecting a checkbox should display the page and tag on the home page
    When I go to the restaurant feature page for "Piece"
    And I check "Casual"
    And I check "Buffet"
    And I press "Update all features"
    And I go to the soapbox restaurant profile for Piece
    Then I see a navigation link for "Cuisine"
    And I do not see a navigation link for "Design"
    And I see a page header for "Cuisine" with "Casual, Buffet"
    And I do not see a page header for "Design"

  Scenario: Clicking on the detail link takes you to the interior page
    When I go to the restaurant feature page for "Piece"
    And I check "Casual"
    And I check "Buffet"
    And I press "Update all features"
    And I go to the soapbox restaurant profile for Piece
    And I follow "Cuisine Details"
    Then I am on the soapbox restaurant feature page for "Piece" and "Cuisine"
    And I see headers for feature categories for "Cuisine"
    And I see "Cuisine" links for "Buffet"
    And I see "Cuisine Style" links for "Casual"
    And I do not see links for "Armenian"

