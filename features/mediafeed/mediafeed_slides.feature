@mediafeedslides
Feature: Mediafeed Slides
  So admins can display large promotions
  On the homepage for media feed
  Slides can be created for mediafeed
  
  Background:
    Given I am logged in as an admin
  
  Scenario: Can get to mediafeed slides on admin
    When I go to the admin landing page
    Then I should see "Mediafeed Slides" as a link
  
  Scenario Outline: Creating mediafeed slides
    Given I am on the new mediafeed slide admin page
    When I attach an image "mediafeed_slide.jpg" to "mediafeed_slide_image"
    And I fill in "Photo credit" with "<photo_credit>"
    And I fill in "Title" with "<title>"
    And I fill in "Excerpt" with "<excerpt>"
    And I fill in "Link" with "<link>"
    And I press "Save"
    When I go to the mediafeed home page
    Then I should see an article with the "title" "<title>"
    And I should see an article with the "data-url" "<link>"
    And I should see an article with the "data-caption" "<excerpt>"
    And I should see an article with the "data-photo-credit" "<photo_credit>"
  
  Examples:
    | photo_credit | title              | excerpt               | link                       |
    | Joe Sak      | Joe Sak's Slide    | A slide by Joe Sak    | http://www.joesak.com      |
    | Edward Blake | Ed Blake's Slide   | A slide by Ed Blake   | http://www.edwardblake.net |
    | Sonia Yoon   | Sonia Yoon's Slide | A slide by Sonia Yoon | http://www.soniablade.com  |
    | Nic Aitch    | Nic Aitch's Slide  | A slide by Nic Aitch  | http://www.nicinabox.com   |