@mediafeed
Feature: Media Feed Routing
  Browsing to /media_feed will
  Show the media_feed layouts
  
  Scenario: Visiting /media_feed
    Given I am on the homepage
    When I go to the media feed homepage
    Then I should see the media feed layout