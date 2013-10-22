@coached
Feature: Coached Status Updates
  So that I can update my SF status with meaningful, interesting things, 
  As a SF member who doesn’t know what to say in his/her SF status update, 
  I want to see status update suggestions, coached from RIA staff, that are seasonally relevant.


  Background:
    Given I am logged in as a normal user
    Given the following date_range records:
    | name      | start_date | end_date   |
    | Christmas | 2009-12-01 | 2009-12-26 |
    And the following coached status messages:
    | message                   | season     |
    | Christmas Menu coming up? | Christmas  |


  Scenario: Seeing a Coached Status during the specified time
    Given the current date is "2009-12-20"
    And I am on the social media page
    Then I should see "Christmas Menu coming up?"

  Scenario: Not displaying message out of date range
    Given the current date is "2009-10-02"
    And I am on the social media page
    Then I should not see "Christmas Menu coming up?"


  Scenario: Adding a Coached Status
    Given I am logged in as an admin
    Given the following date_range records:
    | name      | start_date | end_date   |
    | Christmas | 2009-12-01 | 2009-12-26 |
    When I go to the coached status updates page
    Then I should see "New Coached Status Update"

    When I follow "New Coached Status Update"
    And I fill in "Message" with "Been to the farmer's market lately?"
    And I select "Christmas" from "Time of Year"
    And I press "Save"

    Then I should see "Awesome, you've just added the Coached Status Update"
