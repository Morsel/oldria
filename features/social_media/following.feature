@following
Feature: Follow a SpoonFeed member, See who's following me
  So that I can increase my social network at SF
  As a SpoonFeed member
  I want to follow other SF members and see what they're up to

  So that SF helps me social network and do better marketing
  As a SpoonFeed member
  I want to see a list of folks who are following me

  Background:
    Given the following user records:
      | username | email              | name           | password |
      | friendly | friend@example.com | John Appleseed | secret   |
      | otherguy | otherguy@msn.com   | Sarah Cooper   | secret   |
    Given I am logged in as "friendly" with password "secret"

@wip
  Scenario: Find someone and follow them
    Given I am on the soapbox profile page for "otherguy"
    When I follow "Follow this user"
    Then I should see "You are now following Sarah Cooper"
    And "friendly" should be following 1 user

@wip
  Scenario: Unfollow someone
    Given "friendly" is following "otherguy"
    When I am on the soapbox profile page for "otherguy"
    And I follow "Stop following this user"
    Then I should see "you aren't following Sarah Cooper anymore"
    And "friendly" should be following 0 users

@wip
  Scenario: You can't follow yourself
    Given I am on the soapbox profile page for "friendly"
    Then I should not see "Follow this user"

@wip
  Scenario: Viewing Friends Activity
    Given I am following "otherguy"
    And "otherguy" has the following status messages:
      | message        |
      | I just ate     |
      | I ate too much |
