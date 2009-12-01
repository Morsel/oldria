@restaurant
Feature: Manage restaurants
  In order to fix restaurant information and keep it accurate
  As an RIA Staff Member
  I want to be able to manage all restaurants and their information


  Scenario: Editing a Restaurant name
    Given the following restaurant records:
      | name         | city    | state |
      | Normal Pants | Chicago | IL    |
    Given I am logged in as an admin
    And I am on the admin restaurants page
    When I follow "edit"
    And I fill in "Name" with "Fancy Pants"
    And I press "Save"
    Then I should see "updated restaurant"
    And I should see "Fancy Pants"
    And I should be on the admin restaurants page
