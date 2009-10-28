Feature: Media request administration
  So that bad MRs aren't sent out to tons of people who will get angry
  And So that the MRs are formulated to ensure member use the system and don't contact media directly outside the system
  As a RIA Staff
  I want to to view, edit, and and approve Media Requests for sending that are in a queue


  Background:
    Given the following confirmed users:
      | username | password |
      | sam      | secret   |
    And "sam" has a media request from a media member with:
      | Message   | Do you like pizza? |
      | Due date  | 2009-10-02         |
    And I am logged in as an admin


  Scenario: Approve an okay media request
    Given I am on the list of media requests page
    Then the media request for "sam" should be pending
    When I approve the media request
    Then "sam" should have 1 media request
    Then the media request for "sam" should be approved
  
