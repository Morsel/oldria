Feature: Media requests
  In order to administer media requests
  As a RIA Staff
  I want to see all Media Requests, and all user responses to them

  Background:
    Given I am logged in as an admin
    And the following media_request records:
      | due_date   | message         |
      | 2009-12-01 | I can haz food? |


  Scenario: Viewing a list of Media Requests
    Given I am on the admin landing page
    When I follow "Media Requests"
    Then I should see a list of media requests
    And I should see "I can haz food?"
  