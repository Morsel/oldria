@focus
Feature: Media requests
  In order to find out valuable information
  As a Media member
  I want to send media requests and have SpoonFeed members respond


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
    Given the following confirmed users:
      | username | password |
      | sam      | secret   |
      | john     | secret   |
    Given I am logged in as a media member
    When I create a new media request with:
      | Message    | Are cucumbers good in salad? |
      | Recipients | sam, john                    |
    And I logout

    Given I am logged in as "sam" with password "secret"
    When I go to the dashboard
    Then I should see "Are cucumbers good in salad?"