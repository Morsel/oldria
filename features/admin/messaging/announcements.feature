@admin @messaging
Feature: Admin Messaging: Announcements
  So that SF Staff can alert users to new features, for example
  As a SF staff member
  I want to make announcements that everyone will see

  Background:
    Given a restaurant named "Corner Pocket" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
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

@emails
  Scenario: New Announcement notification, user prefers no emails
  Given there are no Admin Messages in the system
  And "sam" prefers to not receive direct message alerts
  And I am on the new Announcement page
  When I fill in "Message" with "Today is party day!"
  And I press "Save"
  Then "sam@example.com" should have no emails

@emails
  Scenario: New Announcement notification, user prefers emails
    Given "sam" prefers to receive direct message alerts
    And I am on the new Announcement page
    When I fill in "Message" with "Today is party day!"
    And I press "Save"
    Then "sam@example.com" should have 1 email

@emails
  Scenario: New Announcement notification, user has set a notification email
  # Announcements should not use the notification email address
    Given "sam" prefers to receive direct message alerts
    And "sam" has set a notification email address "assistant@myrestaurant.com"
    And I am on the new Announcement page
    When I fill in "Message" with "Today is party day!"
    And I press "Save"
    Then "sam@example.com" should have 1 email
