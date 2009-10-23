Feature: Media request conversations
  So that I can can converse about an MR
  As a Media user or recipient of a media request
  I want to see a dated comment box with attachments on the MR conversation page, most recent on top
  

  Background:
    Given the following confirmed users:
      | username | password | first_name | last_name |
      | sam      | secret   | Sam        | Smith     |
    Given the following media users:
      | username | password | publication    |
      | mediaguy | secret   | New York Times |

@focus
  Scenario: Responding to a media request
    Given "sam" has a media request from "mediaguy" with:
      | Message | Do you like cheesy potatoes? |
      | Status  | approved                     |
    And I am logged in as "sam" with password "secret"
    When I go to the dashboard
    Then I should see /writer[\n\s]*from New York Times/
    And I should see "Do you like cheesy potatoes?"

    When I follow "reply" within the "Media Requests" section
    Then the media request should have 0 comments

    When I leave a comment with "Of course I love cheesy potatoes!"
    Then the media request should have 1 comment

    Given I am logged in as "mediaguy" with password "secret"
    When I go to the homepage
    Then I should see "Sam Smith said"
