@media @mediarequest @search
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
    When I perform the raw search:
      | restaurant_name_eq | South of the Border |
    Then I should see "South of the Border"

  Scenario: Searching by city
    Given "South of the Border" restaurant is in the "New York NY" metro region
    And I am on the media request search page
    When I perform the raw search:
      | restaurant_metropolitan_area_name_eq | New York NY |
    Then I should see "South of the Border"

  Scenario: Searching by other criteria
    Given the restaurant "South of the Border" is in the region "Midwest"
    And I am on the media request search page
    When I perform the raw search:
      | restaurant_james_beard_region_name_eq | Midwest |
    Then I should see "South of the Border"

@regression
  Scenario: Searching by restaurant role
    Given I am on the media request search page
    When I perform the raw search:
      | restaurant_role_name_eq | Sommelier |
    Then I should see "South of the Border"
    And I should see "Southtown Borders"
