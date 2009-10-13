Feature: Media requests
  In order to find out valuable information
  As a Media member
  I want to send media requests and have SpoonFeed members respond


  Background:
    Given the following confirmed users:
      | username | password |
      | sam      | secret   |
      | john     | secret   |


  Scenario: A new media request
    Given I am logged in as a media member
    Given I am on the homepage
    When I follow "New Media Request"
    And I fill in the following:
      | Message | Cucumber recipes |
    And I press "Submit"
    Then I should see "held for approval"
    When I go to the homepage
    Then I should see "Cucumber recipes"
    # And my media request should be held for moderation


  Scenario: A new media request shows up on my dashboard
    Given I am logged in as a media member
    When I create a new media request with:
      | Message    | Are cucumbers good in salad? |
      | Recipients | sam, john                    |
    And I logout

    Given I am logged in as "sam" with password "secret"
    When I go to the dashboard
    Then I should see "Are cucumbers good in salad?"


  Scenario: Responding to a media request
    Given "sam" has a media request from a media member with:
      | Message | Do you like cheese? |
    And I am logged in as "sam" with password "secret"
    When I go to the dashboard
    And I follow "reply" within the "Media Requests" section
    And I fill in "Comment" with "I love cheese!"
    And I press "Submit"
    Then the media request should have 1 comment