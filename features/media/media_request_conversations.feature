@media @mediarequest
Feature: Media request discussions
  So that I can can converse about an MR
  As a Media user or recipient of a media request
  I want to see a dated comment box with attachments on the MR conversation page, most recent on top


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
    Given I am on the media request conversation page
    When I leave a comment with "Of course I love cheesy potatoes!"
    Then the media request should have 1 comment
