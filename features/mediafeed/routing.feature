# @mediafeed
# Feature: Media Feed Routing
#   Browsing to /media_feed will
#   Show the media_feed layouts
#   
#   Background:
#     Given I am logged in as an admin
#     When I create a new mediafeed page with:
#       | Title                       | About MediaFeed             |
#       | Slug                        | about                       |
#       | mediafeed_page_content_editor | This page explains a lot. |
#   
#   Scenario: Visiting /mediafeed
#     Given I am not logged in
#     And I am on the homepage
#     When I go to the mediafeed home page
#     Then I should see the media feed layout
#     
#   Scenario: Viewing the Media Feed about page
#     And I go to "mediafeed/about"
#     Then I should see the media feed layout
#     And I should see "About MediaFeed"
#     
#   Scenario: Mediafeed Homepage has an "hp" class on the #main div
#     Given I am on the mediafeed home page
#     Then the "main" div should have the class "hp clear clearfix"
#     When I go to "mediafeed/about"
#     Then the "main" div should not have the class "hp clear clearfix"