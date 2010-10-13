@soapbox
Feature: Soapbox pages

  Scenario: Viewing the site's about page
  Given I am logged in as an admin
  When I create a new soapbox page with:
    | title   | About Soapbox             |
    | slug    | about                     |
    | content | This page explains a lot. |
  And I go to "soapbox/about"
  Then I should see "About Soapbox"
