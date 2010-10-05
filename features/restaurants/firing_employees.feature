@fired  
Feature: Fire an employee
  So that I can manage my accounts / restaurants,
  As an owner who has an employee who quit,
  I want to remove them from the restaurant.

  Background:
    Given a restaurant named "Crazy Eights" with the following employees:
      | username | password | email            | name      | role      |
      | mgmt     | secret   | mgmt@example.com | Mgmt Joe  | Manager   |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      |
      | john     | secret   | john@example.com | John Doe  | Sommelier |
    And "mgmt" is the account manager for "Crazy Eights"
    And I am logged in as "mgmt" with password "secret"
	

  Scenario: I can see the delete link on employee cards
    Given I am on the employees page for "Crazy Eights" 
    Then I should see "Delete"
    
  Scenario: Delete the employment
    Given I am on the employees page for "Crazy Eights"
    When I follow "Delete" within "#user_2"
    Then I should see "Sam Smith was removed from Crazy Eights"
    And I should not see "Sam Smith Chef"
    And "sam" should still exist