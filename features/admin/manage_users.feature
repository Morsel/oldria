@users
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
    And I press "Save"
    Then I should be on the admin users landing page
    And I should see "User was successfully updated"


  Scenario: Editing admin status of a user
    When I go to the admin edit page for "jimbob"
    And I select "Admin" from "Role"
    And I press "Save"
    Then I should see "User was successfully updated"
    And "jimbob" should be an admin


@preconfirmed
  Scenario: Add a user from the admin interface
    Given I am on the admin new user page
    When I fill in "Email" with "joesak.com@gmail.com"
    And I fill in "Username" with "joemsak"
    And I fill in "Password" with "blAh1!lol"
    And I fill in "Confirm password" with "blAh1!lol"
    And I press "Save"
    Then "joemsak" should be a confirmed user
    And "joesak.com@gmail.com" should have 0 emails
