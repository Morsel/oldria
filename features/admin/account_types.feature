Feature: Managing Account Types
  So that SF can identify its members and offer the right kinds of products/services, 
  As a SF Admin
  I want to identify different Account Types, such as food professional, a journalist, or a concierge.


  Background:
    Given I am logged in as an admin

  Scenario: Adding a new account type
    Given I am on the admin landing page
    When I follow "Account Types"
    And I follow "New Account Type"
    And I fill in "Name" with "An Account Type"
    And I press "Submit"
    Then I should be on the list of account types
    And I should see "Successfully created account type"
    And I should see "An Account Type"