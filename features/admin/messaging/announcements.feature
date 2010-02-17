@admin @messaging
Feature: Admin Messaging: Announcements
  So that SF Staff can alert users to new features, for example
  As a SF staff member
  I want to make announcements that everyone will see

  Background:
    Given a restaurant named "Corner Pocket" with the following employees:
      | username | name      | role      | subject matters |
      | sam      | Sam Smith | Chef      | Food, Pastry    |
      | john     | John Doe  | Sommelier | Beer, Wine      |
    Given I am logged in as an admin


  Scenario: Announcements are sent to everyone
    Given there are no Admin Messages in the system
    And I am on the new Announcement page
    When I fill in "Message" with "We've got Direct Messages!"
    And I press "Save"
    Then I should see list of Announcements
    And I should see "We've got Direct Messages!"
    And "sam" should have 1 Announcement message
    And "john" should have 1 Announcement message