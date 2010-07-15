@facebook
Feature: Facebook update
  So that I can update my Facebook account without having to go over there,
  As a SF member and Facebook member,
  I want to update my Facebook status with my SF status.

  Background:
    Given Facebook is functioning
    
  Scenario: Updating Facebook status when entering a new status
    Given the following confirmed user:
    | username  | password | facebook_id | facebook_access_token |
    | booker    | secret   | 123456      | sometoken             |
    And I am logged in as "booker" with password "secret"
    Given I am on the statuses page for "booker"
    When I fill in "Status" with "My status is..."
    And I check "Post to Facebook?"
    And I press "Post"
    And I go to the statuses page for "booker"
    Then I should see "and on Facebook"
