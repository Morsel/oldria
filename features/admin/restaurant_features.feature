Feature: RIA admin of restaurant features
  In order to administer restaurant features
  As an RIA admin
  I want to be able to add, remove, and edit restaurant features

  Background:
    Given I am logged in as an admin
    And the following restaurant features:
      | page    | category      | value    |
      | Cuisine | Cuisine style | Casual   |
      | Cuisine | Cuisine       | Buffet   |
      | Cuisine | Cuisine type  | Armenian |
      | Design  | Decor         | Ugly     |

  Scenario: Basic admin display
    When I go to the admin restaurant feature page
    Then I see the page headers
    And I see the category headers
    And I see the category values

  Scenario: Create a page
    When I go to the admin restaurant feature page
    And I fill in "Add a new page header" with "Accolades"
    And I press "Add page"
    Then I am on the admin restaurant feature page
    And I see a page named "Accolades"

  Scenario: Create a category
    When I go to the admin restaurant feature page
    And I fill in "Add a category in Cuisine" with "Kids Menu"
    And I press "Add Cuisine category"
    Then I am on the admin restaurant feature page
    And I see a category named "Kids Menu" in the page "Cuisine"

  Scenario: Create a tag
    When I go to the admin restaurant feature page
    And I fill in "Add a feature in Cuisine style" with "Pretty"
    And I press "Add a feature to Cuisine style"
    Then I am on the admin restaurant feature page
    And I see a tag named "Pretty" in the category "Cuisine style"


