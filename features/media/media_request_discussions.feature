@media @mediarequest
Feature: Media request discussions
  So that I can can converse about an MR
  As a Media user or recipient of a media request
  I want to see a dated comment box with attachments on the MR conversation page, most recent on top
  And fill in comments in response


  Background:
    Given there are no media requests
    Given the following confirmed users:
      | username | password | first_name | last_name |
      | sam      | secret   | Sam        | Smith     |
    Given the following media users:
      | username | password | publication    |
      | mediaguy | secret   | New York Times |


  Scenario: Responding to a media request
    Given "sam" has a media request from "mediaguy" with:
      | Message | Do you like cheesy potatoes? |
      | Status  | approved                     |
    And I am logged in as "sam" with password "secret"
    When I visit the media request discussion page for "Do you like cheesy potatoes?"
    And I leave a comment with "Of course I love cheesy potatoes!"
    Then I should see "Thanks: your answer has been saved"
    And the media request should have 1 comment

    Given I am logged in as "mediaguy" with password "secret"
    When I visit the Mediafeed media request discussion page for "Do you like cheesy potatoes?"
    Then I should see "Of course I love cheesy potatoes!"
    And I leave a comment with "Thanks for your quick response, Sam"
    # And I fill in "comment_comment" with "Thanks for your quick response, Sam"
    # And I press "Post Comment"
    Then the media request should have 2 comments
