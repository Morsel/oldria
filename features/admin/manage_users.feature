Feature: Manage users
  So that staff can fix things and manage users
  As an RIA Staff Member
  I want to edit user accounts, including acount type

  Background:
    Given the following confirmed users:
      | username | email       |
      | jimbob   | jim@bob.com |
    And I am logged in as an admin

  Scenario: Editing a username
    When I go to the admin edit page for "jimbob"
    And I fill in "Username" with "boomoo"
    And I press "Update"
    Then I should be on the admin users landing page
    And I should see "User was successfully updated"


  Scenario: Editing admin status of a user
    When I go to the admin edit page for "jimbob"
    Then the "Admin?" checkbox should not be checked
    
    When I check "Admin?"  
    And I press "Update"
    Then I should see "User was successfully updated"
    And "jimbob" should be an admin
    
    When I go to the admin edit page for "jimbob"
    Then the "Admin?" checkbox should be checked


  Scenario: Editing the account type of a user
    Given "jimbob" has a "Media" account type
    When I go to the admin edit page for "jimbob"
    Then I should see "Account type"
    When I select "Concierge" from "Account type"
    And I press "Update"
    Then I should see "User was successfully updated"
    And "jimbob" should have a "Concierge" account type


  Scenario: Seeing account type on index view
    Given "jimbob" has a "Media" account type
    When I am on the admin users landing page
    Then I should see that "jimbob" has a "Media" account type
  