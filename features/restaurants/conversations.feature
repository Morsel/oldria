@conversations
Feature: conversations with a group of users
  In order to allow a user to start a conversation with a group of other users
  As a regular user
  I want to find other people to have a conversation with, and post a message to them
  
  Background:
    Given there are no discussions
    Given a restaurant named "Normal Pants" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
      | jim      | secret   | jim@example.com  | Jim Smith | Assistant | Beer            |
    Given a restaurant named "Fancy Lamb" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    And the restaurant "Normal Pants" is in the region "Midwest"
    And the restaurant "Fancy Lamb" is in the region "Southwest"
    And I am logged in as "sam"

@javascript
  Scenario: a user starts a conversation
    Given I go to the new conversations page
    And I fill in "Subject" with "Is your refrigerator running?"
    And I check "Beer"
    And I check "Wine"
    And I press "Post"
    Then "jim" should have 1 discussion
    And "john" should have 1 discussion