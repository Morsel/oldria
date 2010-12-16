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
      | joemsak  | secret   | joe@sample.com  |
  Scenario: Show user popup with new announcements once
    Given "joemsak" should have 2 Unread Announcement message
    And  I am logged in as "joemsak" with password "secret"
    Then I should see unread announcement popup
    And "joemsak" should have 0 Unread Announcement message
    Then I am on the dashboard
    And I should not see unread announcement popup

