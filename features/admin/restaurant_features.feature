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

  Scenario: Delete a page links
    Given a restaurant feature page named "Beverages"
    When I go to the admin restaurant feature page
    Then I see a delete link for the page "Beverages"
    And I do not see a delete link for the page "Cuisine"

@javascript
  Scenario: Actually delete a page
    Given a restaurant feature page named "Beverages"
    When I go to the admin restaurant feature page
    And I click on the delete link for the page "Beverages"
    Then I am on the admin restaurant feature page
    And I do not see the page "Beverages"

  Scenario: Delete a category links
    Given a restaurant feature category named "Cheesburgers" in the page "Cuisine"
    When I go to the admin restaurant feature page
    Then I see a delete link for the category "Cheesburgers"
    Then I do not see a delete link for the category "Cuisine type"

@javascript
  Scenario: Actually delete a category
    Given a restaurant feature category named "Cheesburgers" in the page "Cuisine"
    When I go to the admin restaurant feature page
    And I click on the delete link for the category "Cheesburgers"
    Then I am on the admin restaurant feature page
    And I do not see the category "Cheesburgers"

  Scenario: Delete a tag links
    Given a restaurant named "Restaurant"
    And the restaurant "Restaurant" has the tag "Ugly"
    When I go to the admin restaurant feature page
    Then I see a delete link for the tag "Casual"
    Then I do not see a delete link for the tag "Ugly"

@javascript
  Scenario: Actually delete a feature
    When I go to the admin restaurant feature page
    And I click on the delete link for the feature "Ugly"
    Then I am on the admin restaurant feature page
    And I do not see the feature "Ugly"

# Advanced edit scenarios
#  Scenario: Move a category to a new page
#  Scenario: Mark a category as important

