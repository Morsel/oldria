@focus
Feature: Media requests
  In order to find out valuable information
  As a Media member
  I want to send media requests and have SpoonFeed members respond


  Background:
    Given the following confirmed users:
      | username | password | email            | name      |
      | sam      | secret   | sam@example.com  | Sam Smith |
      | john     | secret   | john@example.com | John Doe  |
    Given the following media users:
      | username | password |
      | mediaman | secret   |


  Scenario: A new media request
    Given I am logged in as "mediaman" with password "secret"
    When I create a new media request with:
      | Message    | Are cucumbers good in salad? |
      | Due date   | 2009-10-10                   |
    Then I should see "held for approval"


  Scenario: A new media request shows up on my dashboard
    Given "sam" has a media request from "mediaman" with:
      | Message | Where are the best mushrooms? |
      | Status  | approved                      |
    And "sam" has a media request from "mediaman" with:
      | Message | This message has not been approved |
      | Status  | pending                            | 
    And I am logged in as "sam" with password "secret"
    When I go to the dashboard
    Then I should see "Where are the best mushrooms?"
    But I should not see "This message has not been approved"


  Scenario: Responding to a media request and conversations
    Given "sam" has a media request from "mediaman" with:
      | Message   | Do you like cheese? |
      | Due date  | 2009-10-02          |
      | Status    | approved            |
    And I am logged in as "sam" with password "secret"
    When I go to the dashboard
    Then I should see "Do you like cheese?"

    When I follow "reply" within the "Media Requests" section
    And I fill in "Comment" with "I love cheese!"
    And I press "Submit"
    Then the media request should have 1 comment

    Given I am logged in as "mediaman" with password "secret"
    When I am on the homepage
    Then I should see /replied less than a minute ago/
    When I follow "Sam Smith replied less than a minute ago"
    And I fill in "Comment" with "Thanks for your quick response, Sam"
    And I press "Submit"
    Then the media request should have 2 comments

  Scenario: A media requests notifications are emailed to recipients
    Given "sam" has a media request from "mediaman" with:
      | Message | Where are the best mushrooms? |
    And an admin has approved the media request for "sam"
    Then "sam@example.com" should have 1 email
    And "john@example.com" should have 0 emails
    Given I am logged in as "sam" with password "secret"
    When I go to the dashboard
    Then I should see "Where are the best mushrooms?"
    But I should not see "This message has not been approved"
