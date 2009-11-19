@media @mediarequest
Feature: Media faceted member search
  In order to find people to send things to
  As a Media member
  I want to search for people by criteria such as region, cuisine type

  Background:
    Given a restaurant named "South of the Border" with the following employees:
      | email            | name      | role      | subject matters |
      | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
      | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    And the following media users:
      | username | password |
      | mediaman | secret   |
    And I am logged in as "mediaman" with password "secret"


  Scenario: Searching by restaurant name
    Given I am on the media request search page
    When I perform the search:
      | Restaurant Name | South of the Border |
    And I select "South of the Border" as a recipient
    And I press "Next"
    Then "mediaman" should have a new draft media request
    And I should see "Compose Media Request"
    And I should see /To:(\s)*South of the Border/


  Scenario: Searching by other criteria
    Given the restaurant "South of the Border" is in the region "Midwest"
    And I am on the media request search page
    When I perform the search:
      | Region | Midwest |
    Then I should see "South of the Border"
