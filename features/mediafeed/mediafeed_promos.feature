@mediafeedpromos
Feature: Mediafeed Promos
  So admins can display small promotions
  On the homepage for media feed
  Promos can be created for mediafeed
  
  Background:
    Given I am logged in as an admin
  
  Scenario: Can get to mediafeed promos on admin
    When I go to the admin landing page
    Then I should see "Mediafeed Promos" as a link
  
  Scenario Outline: Creating mediafeed promos
    Given I am on the new mediafeed promo admin page
    And I fill in "Title" with "<title>"
    And I fill in "Body" with "<body>"
    And I fill in "Link" with "<link>"
    And I fill in "Link text" with "<link_text>"
    And I press "Save"
    When I go to the mediafeed home page
    Then I should see "<title>" as a link to "<link>"
    And I should see "<link_text>" as a link to "<link>"
    And I should see "<body>"
    
  
  Examples:
    | title              | body                  | link                       | link_text       |
    | Joe Sak's Promo    | A Promo by Joe Sak    | http://www.joesak.com      | learn more      |
    | Ed Blake's Promo   | A Promo by Ed Blake   | http://www.edwardblake.net | go now!         |
    | Sonia Yoon's Promo | A Promo by Sonia Yoon | http://www.soniablade.com  | sonia's site    |
