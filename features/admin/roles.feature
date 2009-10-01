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


