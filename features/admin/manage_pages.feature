Feature: Manage pages
  So that I can publish marketing copy content to the site,
  As an RIA admin, 
  I want to be able to manage static content pages. 


  Background: 
    Given the following user records:
    | username | password | admin |
    | user     | user     | false |
    | admin    | admin    | true  |
    And the following page records:
    | title   |
    | Contact |

  Scenario: list static pages
    Given I am logged in as "admin" with password "admin"
    When I am on the admin list static pages page
    Then I should see the admin interface
    Then I should see the static page name "Contact"

    Given I am logged in as "user" with password "user"
    When I am on the admin list static pages page
    Then I should see the "Authorized Users Only" error message
