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
    Then I should see "invite this person"

    When I fill in "First Name" with "David"
    And I fill in "Last Name" with "Dinkle"
    And I press "Invite User"
    Then I should see "Thanks for recommending a new member"
    
    When I logout
    And I am logged in as an admin
    And I go to the admin invitations page
    And I follow "accept"
    Then "daviddinkle" should be a confirmed user
    And "dinkle@example.com" should have 1 email

    When I logout
    And "dinkle@example.com" opens the email with subject "SpoonFeed: You're invited"
    Then I should see "David Dinkle" in the email body

    # Show the name of the inviter in the email
    And I should see "Jim Jones" in the email body

    And I should see an invitation URL in the email body
    When I click the first link in the email
    Then I should see "Successfully logged in"
    And "daviddinkle" should be a confirmed user
    And "Duck Soup" should have 2 employees
    And I should be on the complete registration page

  Scenario: Making an employee public
    Given I have just created a restaurant named "Jimmy's Diner"
    When I follow "Add employee"
    And I fill in "Employee Email" with "betty@example.com"
    And I check "Display on public profile?"
    And I press "Submit"
    And I press "Yes"
    When I go to the the soapbox restaurant profile for Jimmy's Diner
    Then I should see an employee named "Betty Davis"

  Scenario: Making an employee public on the main page
    Given I have just created a restaurant named "Jimmy's Diner"
    And "betty" is an employee of "Jimmy's Diner"
    When I go to the employees page for "Jimmy's Diner"
    Then I should see "will not be displayed"
    When click to make "betty" public
    Then I should see that "betty" is public

  Scenario: Sorted Employees
    Given I have just created a restaurant named "Jimmy's Diner"
    And "betty" is an employee of "Jimmy's Diner" with public position 3
    And "bob" is an employee of "Jimmy's Diner" with public position 2
    When I go to the soapbox restaurant profile for Jimmy's Diner
    Then I should see the employees in the order "Bob Davy, Betty Davis"

