@feeds
Feature: Feeds
  In order to have users use SpoonFeed as an easy news source
  As an admin
  I want to provide an RSS URL for a feed, override the default title provided by the feed, select some feeds as "default on" for users, so that users who haven't set preferences will have these on, and set order of the feeds


  Background:
    Given I am logged in as an admin


  Scenario: Adding a new feed
    When I create a new feed with:
      | Feed Url | http://feeds.neotericdesign.com/neotericdesign |
    Then I should see "Success"
    And I should see "Neoteric Design"


  Scenario: Removing a feed
    Given a feed exists with a title of "Newbie"
    When I go to the admin feeds page
    And I follow "destroy"
    Then there should be no feeds in the system


  Scenario: Marking a feed as featured
    Given a feed exists with a title of "Special"
    When I go to the admin feeds page
    And I follow "edit"
    And check "Featured"
    And press "Save"
    Then the feed with title "Special" should be featured


  Scenario: Feed Categories
    Given a feed exists with a title of "Categoryless"
    And a feed category exists with a name of "Food Blogs"
    When I go to the admin feeds page
    And I follow "edit"
    And I fill in "Title" with "Latest Food Blog"
    And select "Food Blogs" from "Category"
    And press "Save"
    # Then the feed with title "Special" should belong to the category "Latest Food Blog"
