@statuses
Feature: Manage SpoonFeed Statuses
  So that I can market myself
  As a SpoonFeed member
  I want to update my status


  Background:
    Given the following confirmed user:
    | username | password | name     |
    | freddy   | secret   | Fred Doe |
    And I am logged in as "freddy" with password "secret"


  Scenario: Post a status message
    Given I am on the statuses page for "freddy"
    Then I should see "Statuses for Fred Doe"
    And I should see "Post"

    When I fill in "Status" with "This is my message"
    And I press "Post"
    Then I should see "This is my message"


  Scenario: Looking at someone else's statuses
    Given the following confirmed user:
    | username | password | name     |
    | another  | secret   | John Doe |
    And "freddy" has the following status messages:
    | message                         |
    | I am the user that is logged in |
    And "another" has the following status messages:
    | message        |
    | I just ate     |
    | I ate too much |
    And I am on the statuses page for "another"
    Then I should see "Statuses for John Doe"
    And I should see "I ate too much"
    But I should not see "Post" within "#main"
    And I should not see "Delete"


  Scenario: Clean HTML from input
    Given I am on the statuses page for "freddy"
    When I fill in "Status" with "<h1>This is my message</h1>"
    And I press "Post"
    Then I should see "This is my message"
    And the top message should be "This is my message"
    And the top message should not include a "h1" tag


  Scenario: Auto-link links in status message
    Given I am on the statuses page for "freddy"
    When I fill in "Status" with "Check out http://www.google.com, it's my favorite."
    And I press "Post"
    And the top message should contain a link to "http://www.google.com"
