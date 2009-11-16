@media
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
    Then I should see "South of the Border"
    And I should see "Sam Smith, Chef"
    And I should see "John Doe, Sommelier"

    When I select "John Doe" as a recipient
    And I press "Next"
    Then I should see "New Media Request"
    And I should see "To: John Doe"


  Scenario: Searching by restaurant name
    Given the restaurant "South of the Border" is in the region "Midwest"
    And I am on the media request search page
    When I perform the search:
      | Region | Midwest |
    Then I should see "South of the Border"
    And I should see "Sam Smith, Chef"
    And I should see "John Doe, Sommelier"

