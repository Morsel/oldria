@restaurant
Feature: Associating a Restaurant with its employees
  So that I can have employees associated with my MF Restaurant
  As a Restaurant account manager
  I want to find or invite people to the MediaFeed Restaurant I am setting up.

  Scenario: Adding an Employee after initial signup
    Given the following confirmed users:
      | username | email               | name        | password |
      | mgmt     | manager@example.com | Jim Jones   | secret   |
      | betty    | betty@example.com   | Betty Davis | secret   |
      | cole     | cole@example.com    | Cole Cal    | secret   |
    Given I am logged in as "mgmt" with password "secret"
    And I have just created a restaurant named "Jimmy's Diner"
    Then I should see "Add Employees to your Restaurant"

    When I follow "Add employee"
    And I fill in "Employee Name" with "Betty Davis"
    And I press "Submit"
    Then I should see "Betty Davis"
