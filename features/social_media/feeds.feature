@feeds @focus
Feature: Feeds
  In order to quickly get up to speed on restaurant news
  As a SpoonFeed member
  I want to read news from a curated list of feeds, through a date-sorted list of recent stories

  Background:
    Given a feed exists with a title of "Neoteric"
    And that feed is featured

  Scenario: Reading featured feeds
    Given I am logged in as a spoonfeed member
    When I go to my feeds page
    Then I should see "Neoteric"

  Scenario: title
    Given the feed with title "Neoteric" has the following entries:
      | title      | summary          | url                             |
      | Foody Foo! | Food lorem ipsum | http://www.example.com/food/foo |
    And I am logged in as a spoonfeed member
    When I go to my feeds page
    Then I should see "Neoteric"
    And I should see "Foody Foo!"
