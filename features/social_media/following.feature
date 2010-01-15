Feature: Follow a SpoonFeed member, See who's following me
  So that I can increase my social network at SF
  As a SpoonFeed member
  I want to follow other SF members and see what they're up to

  So that SF helps me social network and do better marketing
  As a SpoonFeed member
  I want to see a list of folks who are following me

  Background:
    And the following user records:
    | username  | email              | name           | password |
    | friendly  | friend@example.com | John Appleseed | secret   |
    | otherguy  | otherguy@msn.com   | Sarah Cooper   | secret   |
    Given I am logged in as "friendly" with password "secret"


  Scenario: Find someone and follow them
    Given I am on the homepage
    When I follow "Search"
    And I fill in "First Name" with "Sarah"
    And I press "Search"
    Then I should see "Sarah Cooper"

    When I follow "follow this user"
    Then I should see "You are now following Sarah Cooper"
    And "friendly" should be following 1 user


  Scenario: Unfollow someone
    Given "friendly" is following "otherguy"
    When I am on the profile page for "friendly"
    And I follow "stop following this user"
    Then I should see "you aren't following them anymore"
    And "friendly" should be following 0 users


  Scenario: You can't follow yourself
    Given I am on the homepage
    When I follow "Search"
    And I fill in "Username" with "friendly"
    And I press "Search"
    Then I should see "John Appleseed"

    When I follow "follow this user"
    Then I should see "You can't follow yourself"
    And "friendly" should be following 0 users


  Scenario: Listing followers
    Given "friendly" is following "otherguy"
    When I am on the profile page for "otherguy"
    And I should see "John Appleseed"


  Scenario: Viewing Friends Activity
    Given I am following "otherguy"
    And "otherguy" has the following status messages:
      | message        |
      | I just ate     |
      | I ate too much |
    When I am on the homepage
    Then I should see "I just ate" within "Friend Activity" section
    And I should see "I ate too much" within "Friend Activity" section

