@restaurant @fired  
Feature: Fire an employee
  So that I can manage my accounts / restaurants,
  As an owner who has an employee who quit,
  I want to remove them from the restaurant.

  Background:
    Given a restaurant named "Crazy Eights" with the following employees:
      | username | password | email            | name      | role      | id  |
      | mgmt     | secret   | mgmt@example.com | Mgmt Joe  | Manager   | 100 |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | 101 |
      | john     | secret   | john@example.com | John Doe  | Sommelier | 102 |
    And "mgmt" is the account manager for "Crazy Eights"
    And I am logged in as "mgmt" with password "secret"

  Scenario: I can see the delete link on employee cards
    Given I am on the employees page for "Crazy Eights" 
    Then I should see "Delete"

@javascript
  Scenario: Delete the employment
    Given I am on the employees page for "Crazy Eights"
    When I follow "Delete" within "#user_101"
    Then I should see "Sam Smith was removed from Crazy Eights"
    And I should not see an employee listing for "sam"
    And "sam" should still exist
