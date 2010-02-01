@feeds
Feature: Feeds
  In order to quickly get up to speed on restaurant news
  As a SpoonFeed member
  I want to read news from a curated list of feeds, through a date-sorted list of recent stories

  Background:
    Given a feed exists with a title of "Neoteric"
    And that feed is featured
    And I am logged in as a normal user

  Scenario: Reading featured feeds
    Given I am logged in as a spoonfeed member
    When I go to my feeds page
    Then I should see "Neoteric"


  Scenario: Viewing a feed entry
    Given the feed with title "Neoteric" has the following entries:
      | title      | summary          | url                             |
      | Foody Foo! | Food lorem ipsum | http://www.example.com/food/foo |
    And I am logged in as a spoonfeed member
    When I go to my feeds page
    Then I should see "Neoteric"
    And I should see "Foody Foo!"
    And I should see "Food lorem ipsum"

@focus
  Scenario: Choosing my favorite feeds
    Given a feed exists with a title of "Foody Times"
    And the feed with title "Neoteric" has the following entries:
      | title      | summary          | url                             |
      | Foody Foo! | Food lorem ipsum | http://www.example.com/food/foo |
    And the feed with title "Foody Times" has the following entries:
      | title             | summary      | url                           |
      | Brownies and Cake | Cake is good | http://www.foodytimes.com/foo |
    When I go to my feeds page
    And I follow "Choose feeds"
    Then I should see "Edit My Feeds"

    When I uncheck "Neoteric"
    And I check "Foody Times"
    And I press "Submit"
    Then I should be on my feeds page
    And I should see "Foody Times"
    But I should not see "Neoteric"
