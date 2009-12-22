@mediarequest
Feature: RIA Media requests
  In order to easily communicate with clients
  As a RIA staff member
  I want send requests to one or many folks, just like the media can


  Background:
    Given a restaurant named "Eight Ball" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    Given the following media users:
      | username | password |
      | mediaman | secret   |
    And there are no media requests
    And I am logged in as an admin

  Scenario: Creating an admin media request
    Given I am on the list of media requests page
    When I follow "Send a New Request"
    And I search for "Eight Ball" restaurant
    And I check "Eight Ball"
    And I check "Chef"
    And I press "Next"
    And I create a new admin media request with:
      | Message    | You're overdue! |
      | Due date   | 2009-10-10      |
      | Status     | approved        |
    Then there should be 1 media request in the system
    And "sam" should have 1 media request
    But "john" should have 0 media requests

    Given I am logged in as "sam" with password "secret"
    When I go to the dashboard
    Then I should see an admin media request
