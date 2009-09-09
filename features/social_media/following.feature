@focus
Feature: Follow a SpoonFeed member
  So that I can increase my social network at SF,
  As a SpoonFeed member,
  I want to follow other SF members and see what they're up to.


  Background:
    And the following user records:
    | username  | email              | name           | password |
    | friendly  | friend@example.com | John Appleseed | secret   |
    | otherguy  | otherguy@msn.com   | Sarah Cooper   | secret   |
    Given I am logged in as "friendly" with password "secret"


  Scenario: Find someone and follow them
    Given I am on the homepage
    When I follow "Search for People"
    And I fill in "First Name" with "John"
    And I press "Search"
    Then I should see "John Appleseed"
    
    When I follow "follow this user"
    Then I should see "You are now following John Appleseed"
    And "friendly" should be following 1 user


  Scenario: Unfollow someone
    Given "friendly" is following "otherguy"
    When I am on the profile page for "friendly"
    And I follow "unfollow this user"
    Then I should see "Successfully unfollowed"
    And "friendly" should be following 0 users