@focus
Feature: Media request conversations
  So that I can can converse about an MR
  As a Media user or recipient of a media request
  I want to see a dated comment box with attachments on the MR conversation page, most recent on top
  

  Background:
    Given the following confirmed users:
      | username | password |
      | sam      | secret   |
    Given the following media users:
      | username | password |
      | mediaguy | secret   |


  Scenario: Responding to a media request
    Given "sam" has a media request from "mediaguy" with:
      | Message | Do you like cheesy potatoes? |
    And I am logged in as "sam" with password "secret"
    When I go to the dashboard
    And I follow "reply" within the "Media Requests" section
    Then the media request should have 0 comments

    When I leave a comment with "Of course I love cheesy potatoes!"
    Then the media request should have 1 comment

    Given I am logged in as "mediaguy" with password "secret"
    When I go to the homepage
    And I follow "reply"
    Then I should see "Of course I love cheesy potatoes!"