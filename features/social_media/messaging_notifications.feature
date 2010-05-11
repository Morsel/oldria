@emails
Feature: Messaging notifications preferences
  In order to know when certain messages are sent out
  As a user
  I want to receive email notifications, according to my preferences

  Background:
    Given the following confirmed users:
    | username | email              | name             |
    | albert   | albert@example.com | Albert Appleseed |
    | zeke     | zeke@example.com   | Zeke Cooper      |


  Scenario: Private Message to No-Email preferring user
    Given I am logged in as "albert" with password "secret"
    When I send a direct message to "zeke" with:
      | body                       |
      | I'm sending you a message! |
    Then "zeke@example.com" should have no emails


  Scenario: Private Message to Email-preferring user
    Given "zeke" prefers to receive direct message alerts
    And I am logged in as "albert" with password "secret"
    When I send a direct message to "zeke" with:
      | body                       |
      | I'm sending you a message! |
    Then "zeke@example.com" should have 1 email

