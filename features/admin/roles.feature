Feature: Member roles
  In order protect certain portions of the site
  As an Admin
  I want to create and manage Roles, such as Member, Client Member and Media


  Scenario: SpoonFeed normal member
    Given I am logged in as a spoonfeed member
    When I am on the dashboard
    Then I should see "Twitter"
    And I should not see "Media Portal"


  Scenario: Media members
    Given I am logged in as a media member
    When I am on the dashboard
    Then I should see "Media Portal"
    And I should not see "Twitter"

  @allow-rescue
  Scenario Outline: Media members access
    Given the following confirmed users:
      | username | email             |
      | jimmy    | jimmy@example.com |
    And I am logged in as a media member
    When I try to visit <page>
    Then I should <action>
  
  Examples:
    | page                         | action              |
    | the admin landing page       | be on the homepage  |
    | the edit page for "jimmy"    | be on the homepage  |
    | the profile page for "jimmy" | see "Access denied" |


  Scenario Outline: Admin members access
    Given the following confirmed users:
      | username | email             |
      | jimmy    | jimmy@example.com |
    And I am logged in as an admin
    When I go to <page>
    Then I should be on <page>

  Examples:
    | page                         |
    | the admin landing page       |
    | the edit page for "jimmy"    |
    | the profile page for "jimmy" |


