Feature: Twitter update
  So that I can update my twitter account without having to go over there, 
  As a SF member and twitter member,
  I want to update my twitter status with my SF status.

  Background:
    Given Twitter is functioning

  Scenario: Updating Twitter Status when typing in new status
    Given the following confirmed user:
    | username  | password | asecret | atoken |
    | tweetie   | secret   | fake    | fake   |
    And I am logged in as "tweetie" with password "secret"
    Given I am on the statuses page for "tweetie"
    When I fill in "Status" with "A Tweet"
    And I check "Also post to Twitter?"
    And I press "Post"
    And I go to the statuses page for "tweetie"
    Then I should see "and on Twitter"

  Scenario: No checkbox for non-Twitter user
    Given the following confirmed user:
      | username  | password |
      | notweets  | secret   |
    And I am logged in as "notweets" with password "secret"
    Given I am on the statuses page for "notweets"
    Then I should not see "Also post to Twitter?"
