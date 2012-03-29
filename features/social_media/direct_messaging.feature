@dm
Feature: Direct messaging
  So that users can communicate privately with each other
  And increase social networking inside the system
  As a SF member
  I want to send a private direct message to another SF member
  And reply to private direct messages that I have received.


  Background:
    Given the following user records:
      | username  | first_name | password |
      | senderman | Albert     | secret   |
      | getterboy | Bob        | secret   |


  Scenario: Send a direct message
    Given I am logged in as "senderman" with password "secret"
    When I send a direct message to "getterboy" with:
      | body                       |
      | I'm sending you a message! |
    Then I should see "Your message has been sent"
    And "getterboy" should have 1 direct message


  Scenario: See a direct message in an "inbox"
    Given "getterboy" has 1 direct message from "senderman"
    And I am logged in as "getterboy" with password "secret"
    When I am on my inbox
    And I follow "Private Messages (1)"
    Then I should see a message from "senderman"


  Scenario: Reply to a message
    Given "getterboy" has 1 direct message from "senderman"
    And I am logged in as "getterboy" with password "secret"
    When I am on my inbox
    And I follow "Private Messages (1)"
    And I follow "reply"
    Then I should see "Albert Albert sent you a message"

    When I fill in "Body" with "This is my reply"
    And I press "Send"
    Then I should see "Your message has been sent"
    And "senderman" should have 1 direct message
