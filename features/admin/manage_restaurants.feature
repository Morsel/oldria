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

  Scenario: Upgrading an account to premium
    Given the following restaurant records:
      | name         | city    | state |
      | Piece        | Chicago | IL    |
    And I am logged in as an admin
    And I am on the admin restaurants page
    Then the listing for "Piece" should not be premium
    When I go to the restaurant show page for "Piece"
    Then the show page should not be premium
    When I am on the admin restaurants page
    When I follow "edit"
    And I check "Premium Account"
    And I press "Save"
    Then I should see "updated restaurant"
    Then the listing for "Piece" should be premium
    When I go to the restaurant show page for "Piece"
    Then the show page should be premium
