@dashboard
Feature: Using dashboard
  So that I view dashboard

  Background:
    Given the following announcements:
      | message            |
      | New Announcement 1 |
      | New Announcement 2 |

  Scenario: Show the announcement popup on the dashboard once and hide it after viewing
    Given I am logged in as a normal user
	And I go to the dashboard
    Then I should see unread announcement popup
    And I should have 0 unread announcements

    Given I am on the dashboard
    Then I should not see unread announcement popup

  Scenario: Show links more when comment very long
    Given answers with long text
    And I am logged in as a normal user
    When I go to the dashboard
    Then I see more link to the answer's expanded view

  Scenario: Show links see more when many comments
    Given 11 comments in dashboard
    And I am logged in as a normal user
    When I go to the dashboard
    Then I should see link "see more"
