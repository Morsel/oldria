@mediafeed
Feature: Media Feed Routing
  Browsing to /media_feed will
  Show the media_feed layouts
  
  Scenario: Visiting /mediafeed
    Given I am on the homepage
    When I go to the media feed homepage
    Then I should see the media feed layout
    
    Scenario: Viewing the Media Feed about page
    Given I am logged in as an admin
    When I create a new mediafeed page with:
      | Title                       | About MediaFeed           |
      | Slug                        | about                     |
      | mediafeed_page_content_editor | This page explains a lot. |
    And I go to "mediafeed/about"
    Then I should see the media feed layout
    And I should see "About MediaFeed"