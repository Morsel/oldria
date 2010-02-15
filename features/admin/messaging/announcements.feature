@admin @messaging
Feature: Admin Messaging: Announcements
  So that SF Staff can alert users to new features, for example
  As a SF staff member
  I want to make announcements that everyone will see

  Background:
    Given I am logged in as an admin

  Scenario: Create a new Announcement
    Given I am on the new Announcement page
    And I fill in "Message" with "We've got Direct Messages!"
    And I press "Save"
    Then I should see list of Announcements
    And I should see "We've got Direct Messages!"

