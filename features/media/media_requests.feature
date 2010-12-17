@mediarequest @media @joesak
Feature: Media requests
  In order to find out valuable information
  As a Media member
  I want to send media requests and have SpoonFeed members respond


  Background:
    Given a restaurant named "Eight Ball" with the following employees:
      | username | password | email             | name       |
      | sarah    | secret   | sarah@example.com | Sarah Jane |
      | john     | secret   | john@example.com  | John Doe   |
      | sam      | secret   | sam@example.com   | Sam Smith  |
    Given the following media users:
      | username | password |
      | mediaman | secret   |
    Given there are no media requests


  Scenario: A new media request is held for approval
    Given I am logged in as "mediaman" with password "secret"
    When I create a media request with message "Are cucumbers good in salad?" and criteria:
      | Restaurant | Eight Ball |
    Then that media request should be pending
    And there should be 1 media request in the system

  Scenario: Media Requests go to the assigned subject matters
    Given "john" handles the subject matter "Beer" for "Eight Ball"
    And "sam" does not handle the subject matter "Beer" for "Eight Ball"
    And subject matter "Beer" is general

    Given I am logged in as "mediaman" with password "secret"
    When I create a media request with message "Are cucumbers good in salad?" and criteria:
       | Subject Matter | Beer |
    And that media request is approved
    Then "sam" should have 0 media requests
    But "john" should have 1 media request

  Scenario: Media Requests always go to omniscient folks
    Given "john" does not handle the subject matter "Beer" for "Eight Ball"
    And "sam" does not handle the subject matter "Beer" for "Eight Ball"
    And subject matter "Beer" is general
    But "sam" is a manager for "Eight Ball"

    Given I am logged in as "mediaman" with password "secret"
    When I create a media request with message "Is beer good in salad?" and criteria:
       | Subject Matter | Beer |
    And that media request is approved
    Then "sam" should have 1 media requests
    But "john" should have 0 media request

  Scenario: Responding to a media request and conversations
    Given "sam" has a media request from "mediaman" with:
      | Message   | Do you like cheese? |
      | Due date  | 2009-10-02          |
      | Status    | approved            |
    And I am logged in as "sam" with password "secret"
    When I go to the media request discussion page
    And I fill in "Comment" with "I love cheese!"
    And I press "Post Comment"
    Then the media request should have 1 comment

    Given I am logged in as "mediaman" with password "secret"
    Given I am on the media request discussion page
    And I fill in "Comment" with "Thanks for your quick response, Sam"
    And I press "Post Comment"
    Then the media request should have 2 comments

  Scenario: Approved media requests notifications are emailed to recipients
    Given "sam" handles the subject matter "Beer" for "Eight Ball"
    And "john" does not handle the subject matter "Beer" for "Eight Ball"
    And subject matter "Beer" is general
    Given I am logged in as "mediaman" with password "secret"
    When I create a media request with message "Are cucumbers good in salad?" and criteria:
       | Subject Matter | Beer |
    And that media request is approved
    Then "sam@example.com" should have 1 email
    And "john@example.com" should have 0 emails
