@mediarequest @media
Feature: Media requests
  In order to find out valuable information
  As a Media member
  I want to send media requests and have SpoonFeed members respond


  Background:
    Given a restaurant named "Eight Ball" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    Given the following media users:
      | username | password |
      | mediaman | secret   |
    Given there are no media requests


  Scenario: A new media request is held for approval
    Given I am logged in as "mediaman" with password "secret"
    When I search for and find "Eight Ball" restaurant
    And I create a new media request with:
      | Message    | Are cucumbers good in salad? |
      | Due date   | 2009-10-10                   |
    Then I should see "media request will be sent shortly"
    And the media request from "mediaman" should be pending
    And there should be 1 media request in the system


  Scenario: Media Requests go to the assigned roles
    Given I am logged in as "mediaman" with password "secret"
    When I search for "Eight Ball" restaurant
    And I check "Eight Ball"
    And I check "Chef"
    And I press "Next"
    And I create a new media request with:
      | Message    | Eight Ball is good? |
      | Due date   | 2009-10-10          |
    Then I should see "media request will be sent shortly"
    And the media request from "mediaman" should be pending
    And there should be 1 media request in the system
    And "sam" should have 1 media request
    But "john" should have 0 media requests


  Scenario: Media Requests go to the assigned subject matters
    Given I am logged in as "mediaman" with password "secret"
    When I search for "Eight Ball" restaurant
    And I check "Eight Ball"
    And I check "Food"
    And I check "Beer"
    And I check "Pastry"
    And I press "Next"
    And I create a new media request with:
      | Message    | Eight Ball is good? |
      | Due date   | 2009-10-10          |
    Then I should see "media request will be sent shortly"
    And the media request from "mediaman" should be pending
    And there should be 1 media request in the system
    And "sam" should have 1 media request
    And "john" should have 1 media requests


  Scenario: A new media request shows up on my dashboard
    Given "sam" has a media request from "mediaman" with:
      | Message | Where are the best mushrooms? |
      | Status  | approved                      |
    And "sam" has a media request from "mediaman" with:
      | Message | This message has not been approved |
      | Status  | pending                            |
    And I am logged in as "sam" with password "secret"
    # When I go to the dashboard
    #     Then I should see "Where are the best mushrooms?"
    #     But I should not see "This message has not been approved"


  Scenario: Responding to a media request and conversations
    Given "sam" has a media request from "mediaman" with:
      | Message   | Do you like cheese? |
      | Due date  | 2009-10-02          |
      | Status    | approved            |
    And I am logged in as "sam" with password "secret"
    # When I go to the dashboard
    #    Then I should see "Do you like cheese?"
    # 
    #    When I follow "reply" within the "Media Requests" section
    Given I am on the media request conversation page
    And I fill in "Comment" with "I love cheese!"
    And I press "Submit"
    Then the media request should have 1 comment

    Given I am logged in as "mediaman" with password "secret"
    # When I am on the homepage
    #     Then I should see /Sam Smith said/
    # When I follow "Conversation with Sam Smith"
    Given I am on the media request conversation page
    And I fill in "Comment" with "Thanks for your quick response, Sam"
    And I press "Submit"
    Then the media request should have 2 comments

  Scenario: A media requests notifications are emailed to recipients
    Given "sam" has a media request from "mediaman" with:
      | Message | Where are the best mushrooms? |
    And an admin has approved the media request from "mediaman"
    Then "sam@example.com" should have 1 email
    And "john@example.com" should have 0 emails
    Given I am logged in as "sam" with password "secret"
    # When I go to the dashboard
    #     Then I should see "Where are the best mushrooms?"
    #     But I should not see "This message has not been approved"
    
@click_anywhere
  Scenario: A media request can be clicked anywhere to reply from the dashboard
    Given "sam" has a media request from "mediaman" with:
    |Message|Where are the best mushrooms?|
    And an admin has approved the media request from "mediaman"
    When I am logged in as "sam" with password "secret"
    And I go to the dashboard