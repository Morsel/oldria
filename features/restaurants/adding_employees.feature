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
    And "betty" has a default employment with the role "Chef"
    And "bob" has a default employment with the role "Barista"
    And "cole" has a default employment with the role "Sous Chef"
    Given I am logged in as "mgmt" with password "secret"

  Scenario Outline: Adding an existing Employee after initial signup
    Given I have just created a restaurant named "Jimmy's Diner"
    And "Jimmy's Diner" should have 1 employee

    When I follow "Add employee"
    And I fill in "Employee email" with "<inputfield>"
    And I press "Submit"
    Then I should see "Are these users an employee at your restaurant?"
    Then I should see "<name>"
    When I press "Yes"
    Then I should see "<name>"
    # The manager plus the new person get email
    And "Jimmy's Diner" should have 2 employees
    And "<username>" should not have a default employment

  Examples:
    | inputfield        | name        | username |
    | betty@example.com | Betty Davis | betty    |
    | betty             | Betty Davis | betty    |
    | Betty Davis       | Betty Davis | betty    |
    | B Davis           | Betty Davis | betty    |
    | bob               | Bob Davy    | bob      |
    | Bob Davy          | Bob Davy    | bob      |
    | cole              | Cole Cal    | cole     |

  Scenario: You can't add an employee twice
    Given I have just created a restaurant named "Jimmy's Diner"
    Then "Jimmy's Diner" should have 1 employee
    Given I have added "betty@example.com" to that restaurant
    Then "Jimmy's Diner" should have 2 employees
    When I follow "Add employee"
    And I fill in "Employee email" with "betty@example.com"
    And I press "Submit"
    And I press "Yes"
    Then I should see "Employee is already associated with that restaurant"
    And "Jimmy's Diner" should only have 2 employees

  Scenario: Inviting a non-existing Employee
    Given I have just created a restaurant named "Duck Soup"
    When I follow "Add employee"
    And I fill in "Employee email" with "dinkle@example.com"
    And I press "Submit"
    Then I should see "invite"

    When I press "Send now"
    Then I should see "Thanks for recommending new members!"
    And "dinkle@example.com" should have 1 email

@javascript
  Scenario: Making an employee private on the main page
    Given I have just created a restaurant named "Jimmy's Diner"
    And "betty" is an employee of "Jimmy's Diner"
    When I go to the employees page for "Jimmy's Diner"
    Then I should see "will be displayed"
    When I click to make "betty" private
    Then I should see that "betty" is private

  Scenario: The difference between a premium and basic employee
    Given I have just created a restaurant named "Jimmy's Diner"
    And that "Jimmy's Diner" has a premium account
    And "betty" is an employee of "Jimmy's Diner"
    And "bob" is an employee of "Jimmy's Diner"
    And the user "betty" has a premium account
    And the user "bob" does not have a premium account
    When I go to the soapbox restaurant profile for "Jimmy's Diner"
    Then I see an employee named "betty" with a link
    And I see an employee named "bob" without a link

  Scenario: Sorted Employees
    Given I have just created a restaurant named "Jimmy's Diner"
    And that "Jimmy's Diner" has a premium account
    And "betty" is an employee of "Jimmy's Diner" with public position 3
    And "mgmt" is an employee of "Jimmy's Diner" with public position 2
    When I go to the soapbox restaurant profile for "Jimmy's Diner"
    Then I should see the employees in the order "Jim Jones, Betty Davis"

