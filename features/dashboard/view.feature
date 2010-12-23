@dashboard
Feature: Using dashboard
  So that I view dashboard

  Background:
    Given the following announcements:
      | message            |
      | New Announcement 1 |
      | New Announcement 2 |

    Given the following confirmed users:
      | username | password | email           |
      | joe298   | secret   | joe298@sample.com  |
  Scenario: Show user popup with new announcements once
    Given "joe298" should have 2 Unread Announcement message
    And  I am logged in as "joe298" with password "secret"
    Then I should see unread announcement popup
    And "joe298" should have 0 Unread Announcement message
    Then I am on the dashboard
    And I should not see unread announcement popup

  Scenario: Show links more when comment very long
    Given answers with long text
    And I am logged in as an admin
    When I go to the dashboard
    Then I see more link to the answer's expanded view

  Scenario: Show links see more when many comments
    Given 11 comments in dashboard
    And I am logged in as an admin
    When I go to the dashboard
    Then I should see link "see more"
    

    

