@discussions @restaurants
Feature: Discussions
  In order to increase communication among my team
  As a Restaurant professional
  I want to invite fellow Restaurant Employees to have discussions, where I can post a topic, and have people from my restaurant respond as comments to that post.

  Background:
    Given a restaurant named "Arabian Nights" with the following employees:
      | username | password | email            | name      | role      |
      | wendy    | secret   | wsue@example.com | Wendy Sue | Manager   |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      |
      | john     | secret   | john@example.com | John Doe  | Sommelier |

  Scenario: Create a new Discussion
    Given there are no discussions
    Given I am logged in as "wendy" with password "secret"
    When I follow "Arabian Nights"
    Then I should see "Restaurant Staff"

    When I follow "Start a discussion"
    And I fill in "Title" with "Where should we eat?"
    And I check "Sam Smith"
    And I press "Post Discussion"
    Then there should be 1 discussion in the system

    # Then "sam@example.com" should have 1 email

