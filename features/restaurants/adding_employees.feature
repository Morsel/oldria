@restaurant
Feature: Associating a Restaurant with its employees
  So that I can have employees associated with my MF Restaurant
  As a Restaurant account manager
  I want to find or invite people to the SpoonFeed Restaurant I am setting up.


  Background:
    Given the following confirmed users:
      | username | email               | name        | password |
      | mgmt     | manager@example.com | Jim Jones   | secret   |
      | betty    | betty@example.com   | Betty Davis | secret   |
      | bob      | bob@example.com     | Bob Davy    | secret   |
      | cole     | cole@example.com    | Cole Cal    | secret   |
    Given I am logged in as "mgmt" with password "secret"


  Scenario Outline: Adding an existing Employee after initial signup
    Given I have just created a restaurant named "Jimmy's Diner"
    Then I should see "Add Employees to your Restaurant"
    And "Jimmy's Diner" should have 1 employee

    When I follow "Add employee"
    And I fill in "Employee Email" with "<inputfield>"
    And I press "Submit"
    Then I should see "Is this who you were looking for?"
    Then I should see "<name>"

    When I press "Yes"
    Then I should see "<name>"
    # The manager plus the new person
    And "Jimmy's Diner" should have 2 employees

  Examples:
    | inputfield        | name        |
    | betty@example.com | Betty Davis |
    | betty             | Betty Davis |
    | Betty Davis       | Betty Davis |
    | B Davis           | Betty Davis |
    | bob               | Bob Davy    |
    | Bob Davy          | Bob Davy    |


  Scenario: You can't add an employee twice
    Given I have just created a restaurant named "Jimmy's Diner"
    Then "Jimmy's Diner" should have 1 employee

    Given I have added "betty@example.com" to that restaurant
    Then "Jimmy's Diner" should have 2 employees

    When I follow "Add employee"
    And I fill in "Employee Email" with "betty@example.com"
    And I press "Submit"
    And I press "Yes"
    Then I should see "Employee is already associated with that restaurant"
    And "Jimmy's Diner" should only have 2 employees


  Scenario: Inviting a non-existing Employee
    Given I have just created a restaurant named "Duck Soup"
    When I follow "Add employee"
    And I fill in "Employee Email" with "dinkle@example.com"
    And I press "Submit"
    Then I should see "Invite an Employee"

    When I fill in "First Name" with "David"
    And I fill in "Last Name" with "Dinkle"
    And I fill in "Username" with "daviddinkle"
    And I fill in "Temporary Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I press "Invite Employee"
    Then I should see "sent an invitation and added to your restaurant"
    And "Duck Soup" should have 2 employees
    And "dinkle@example.com" should have 1 email

    When I logout
    And "dinkle@example.com" opens the email with subject "SpoonFeed: You've been added"
    Then I should see "Welcome" in the email body
    And I should see "David" in the email body

    # Show the name of the inviter in the email
    And I should see "Jim Jones" in the email body

    And I should see an invitation URL in the email body
    When I click the first link in the email
    Then I should see "Successfully logged in"
    And "daviddinkle" should be a confirmed user
    And I should be on the complete registration page
