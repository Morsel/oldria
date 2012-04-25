@dm
Feature: Direct messaging
  So that staff can praise, suggest, or notify SF members privately
  As an RIA staff person
  I want to send a DM to users and they can reply to me.
  These should be visually different from other user DMs.

  Background:
    Given the following user records:
      | username  | password | name     |
      | normalguy | secret   | Jim John |


  Scenario: Sending an Admin Direct Message to a user
    Given I am logged in as an admin
    When I send an admin direct message to "Jim John" with:
      | body                        |
      | You need to fill out a menu |
	And I press "Send"
    Then "normalguy" should have an admin message with body: "You need to fill out a menu"
