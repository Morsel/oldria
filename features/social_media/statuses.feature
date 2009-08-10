Feature: Manage SpoonFeed Statuses
  So that I can market myself
  As a SpoonFeed member
  I want to update my status


  Background:
    Given the following confirmed user:
    | username | password |
    | freddy   | secret   |
    And I am logged in as "freddy" with password "secret"


  Scenario: Post a status message
    Given I am on the statuses page for "freddy"
    Then I should see "Statuses for freddy"
    And I should see "Post"

    When I fill in "Status" with "This is my message"
    And I press "Post"
    Then I should see "This is my message"


  Scenario: Looking at someone else's statuses
    Given the following confirmed user:
    | username | password |
    | another  | secret   |
    And "another" has the following status messages:
    | message        |
    | I just ate     |
    | I ate too much |
    And I am on the statuses page for "another"
    Then I should see "Statuses for another"
    But I should not see "Post"
    And I should not see "Delete"

