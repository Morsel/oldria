@uploads
Feature: User headshots
  In order to show people what I look like
  As a SpoonFeed user
  I want to upload my headshot to display on my profile page


  Background:
    Given the following user records:
    | username | password |
    | emily    | secret   |

  Scenario: Uploading an image
    Given I am logged in as "emily" with password "secret"
    And "emily" has no headshot
    When I follow "My Profile"
    And I attach an avatar "headshot.jpg" to "Upload a Headshot"
    And I press "Upload Headshot"
    Then I should see "Successfully updated your profile"
    And "emily" should have a headshot


  Scenario: Removing headshot
    Given I am logged in as "emily" with password "secret"
    And "emily" has a headshot
    When I follow "My Profile"
    Then I should see my headshot

    When I follow "Remove my headshot"
    Then I should see "removed your headshot from your account"
    And "emily" should not have a headshot


  Scenario: Seeing headshot on portfolio page
    Given the following user records:
    | username | password |
    | jimbob   | secret   |
    | tony     | secret   |
    And "tony" has a headshot
    And I am logged in as "jimbob" with password "secret"
    When I go to the profile page for "tony"
    Then I should see his headshot
