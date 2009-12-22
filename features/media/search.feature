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
    Given a restaurant named "Southtown Borders" with the following employees:
      | email                | name             | role      | subject matters |
      | john@southtown.com   | John Smithsonian | Chef      | Food            |
      | samuel@southtown.com | Samuel Jacksone  | Sommelier | Beer, Wine      |
    And the following media users:
      | username | password |
      | mediaman | secret   |
    And I am logged in as "mediaman" with password "secret"


  Scenario: Searching by restaurant name, exact match
    Given I am on the media request search page
    When I perform the search:
      | Restaurant Name | South of the Border |
    Then I should see "South of the Border"
    But I should not see "Southtown Borders"
    And I select "South of the Border" as a recipient
    And I check "Chef"
    And I press "Next"
    Then "mediaman" should have a new draft media request
    And I should see "Compose Media Request"
    And I should see "South of the Border"


  Scenario: Searching by restaurant name, fuzzy match
    Given I am on the media request search page
    When I perform the search:
      | Restaurant Name | south border |
    Then I should see "South of the Border"
    And I should see "Southtown Borders"

@focus
  Scenario: Searching by city
    Given the restaurant "South of the Border" is in the region "Midwest"
    And "South of the Border" restaurant is in the "Chicago IL" metro region
    And I am on the media request search page
    When I perform the search:
      | Greater Metropolitan Area | Chicago IL |
    Then I should see "South of the Border"


  Scenario: Searching by other criteria
    Given the restaurant "South of the Border" is in the region "Midwest"
    And I am on the media request search page
    When I perform the search:
      | Region | Midwest |
    Then I should see "South of the Border"
