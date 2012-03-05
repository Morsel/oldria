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
    And "jimbob" should have a "Basic" account in the list

  Scenario: Making a basic user complimentary
    Given the user "jimbob" does not have a premium account
    When I go to the admin edit page for "jimbob"
    And I should see that the user has a basic account
    And I follow "Give user a Complimentary Premium Account"
    Then I should be on the admin edit page for "jimbob"
    Then I should see that the user has a complimentary account
    When I am on the admin users landing page
    And "jimbob" should have a "Complimentary" account in the list
    # When I go to the profile page for "jimbob"
    # And "jimbob" should have a "Complimentary" account on the page

  Scenario: Canceling a complimentary account
    Given the user "jimbob" has a complimentary account
    When I go to the admin edit page for "jimbob"
    And I should see that the user has a complimentary account
    And I follow "Cancel the user's Complimentary Premium Account"
    Then I should be on the admin edit page for "jimbob"
    Then I should see that the user has a basic account
    When I am on the admin users landing page
    And "jimbob" should have a "Basic" account in the list
    # When I go to the profile page for "jimbob"
    # And "jimbob" should have a "Basic" account on the page

  Scenario: Converting an existing account to complementary
    Given the user "jimbob" has a premium account
    When I go to the admin edit page for "jimbob"
    And I should see that the user has a premium account
    And I follow "Convert user's premium account to a Complimentary Premium Account"
    Then I should be on the admin edit page for "jimbob"
    Then I should see that the user has a complimentary account
    When I am on the admin users landing page
    And "jimbob" should have a "Complimentary" account in the list
    # When I go to the profile page for "jimbob"
    # And "jimbob" should have a "Complimentary" account on the page

  Scenario: Cancel a non-complimentary premium account
    Given the user "jimbob" has a premium account
    When I go to the admin edit page for "jimbob"
    And I should see that the user has a premium account
    And I follow "Downgrade the user to a basic account"
    Then I should be on the admin edit page for "jimbob"
    Then I should see that the user has a basic account
    When I am on the admin users landing page
    And "jimbob" should have a "Basic" account in the list
    # When I go to the profile page for "jimbob"
    # And "jimbob" should have a "Basic" account on the page
    Then I go to the admin edit page for "jimbob"
    And I don't see that the account for "jimbob" lasts until the end of the billing cycle

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
