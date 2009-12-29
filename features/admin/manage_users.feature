Feature: Manage users
  So that staff can fix things and manage users
  As an RIA Staff Member
  I want to edit user accounts, including account type

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
    Given the following account_type records:
      | name               |
      | Concierge          |
      | Media Professional |
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

@preconfirmed
  Scenario: Add a user from the admin interface
    Given I am on the admin new user page
    When I fill in "Email" with "joesak.com@gmail.com"
    And I fill in "Username" with "joemsak"
    And I fill in "Initial password" with "blAh1!lol"
    And I fill in "Confirm initial password" with "blAh1!lol"
    And I press "Save"
    Then "joemsak" should be a confirmed user
    And "joesak.com@gmail.com" should have 0 emails
