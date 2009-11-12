@restaurant
Feature: Associating a Restaurant with its employees
  So that I can have employees associated with my MF Restaurant
  As a Restaurant account manager
  I want to find or invite people to the MediaFeed Restaurant I am setting up.


  Background:
    Given the following confirmed users:
      | username | email               | name        | password |
      | mgmt     | manager@example.com | Jim Jones   | secret   |
      | betty    | betty@example.com   | Betty Davis | secret   |
      | cole     | cole@example.com    | Cole Cal    | secret   |
    Given I am logged in as "mgmt" with password "secret"


  Scenario: Adding an existing Employee after initial signup
    Given I have just created a restaurant named "Jimmy's Diner"
    Then I should see "Add Employees to your Restaurant"

    When I follow "Add employee"
    And I fill in "Employee Email" with "betty@example.com"
    And I press "Submit"
    Then I should see "Is this who you were looking for?"
    Then I should see "Betty Davis"

    When I press "Yes"
    Then I should see "Betty Davis"
    And "Jimmy's Diner" should have 1 employee


  Scenario: You can't add an employee twice
    Given I have just created a restaurant named "Jimmy's Diner"
    And I have added "betty@example.com" to that restaurant
    When I follow "Add employee"
    And I fill in "Employee Email" with "betty@example.com"
    And I press "Submit"
    And I press "Yes"
    Then I should see "Employee is already associated with that restaurant"
    And "Jimmy's Diner" should only have 1 employee


  Scenario: Inviting a non-existing Employee
    Given I have just created a restaurant named "Duck Soup"
    When I follow "Add employee"
    And I fill in "Employee Email" with "dinkle@example.com"
    And I press "Submit"
    Then I should see "Invite an Employee"

    When I fill in "Name" with "David Dinkle"
    And I fill in "Username" with "daviddinkle"
    And I fill in "Temporary Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I press "Invite Employee"
    Then I should see "Successfully associated employee and restaurant"
    And "Duck Soup" should have 1 employee
    And "dinkle@example.com" should have 1 email

    When I logout
    And "dinkle@example.com" opens the email with subject "MediaFeed: You've been added"
    Then I should see "Welcome" in the email body
    And I should see "David" in the email body
    And I should see an invitation URL in the email body
    When I click the first link in the email
    Then I should see "Successfully logged in"

