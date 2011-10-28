@otm @restaurant
Feature: On the Menu
  In order to allow restaurants to list current menu offerings,
  restaurant managers should be able to enter a name, description, price, and keywords for a dish

  Background:
    Given a restaurant named "Country Dog" with manager "bland"
    And I am logged in as "bland"
    Given a menu item keyword "farm-to-table" with category "Other"

  Scenario: Managers can access the OTM form
    When I go to my restaurants page
    And I follow "Edit On the Menu"
    Then I should see "On the Menu"

  Scenario: Managers can enter an OTM item
    When I go to the new on the menu page for "Country Dog"
    And I fill in "name" with "Pork chop"
    And I fill in "description" with "A braised pork chop served with fruit compote"
    And I fill in "price" with "12.00"
    And I check "farm-to-table"
    And I press "Save"
    Then I should see "saved"
    
  Scenario: Other users can't access the OTM area
    Given the following confirmed user:
      | name       | username |
      | Marko Tony | mtony    |
    And I am logged in as "mtony"
    And I am an employee of "Country Dog" with role "Chef"
    When I go to the new on the menu page for "Country Dog"
    Then I should not see "On the Menu"
    And I should see "You don't have permission to access that page"
