@admin @messaging
Feature: Admin Messaging: Pr Tips
  So that SF Staff can send pr tips to users, for example
  As a SF staff member
  I want to make pr tip posts that everyone will see

  Background:
    Given a restaurant named "Corner Pocket" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    Given I am logged in as an admin


  Scenario: PR Tips are sent to everyone (who is a restaurant user)
    Given there are no PR Tips in the system
    And I am on the new PR Tip page
    When I fill in "Message" with "Be friendly!"
    And I press "Save"
    Then I should see list of PR Tips
    And I should see "Be friendly!"
    And "sam" should have 1 PR Tip message
    And "john" should have 1 PR Tip message

  Scenario: PR Tips are not sent to media users
    Given the following media users:
      | username | password |
      | media    | secret   |
    And there are no PR Tips in the system
    And I am on the new PR Tip page
    When I fill in "Message" with "Smile and nod!"
    And I press "Save"
    Then "media" should have 0 PR Tip messages
    And "media" should have no emails

@emails
  Scenario: New Pr Tip notification, user prefers no emails
  Given there are no Admin Messages in the system
  And "sam" prefers to not receive direct message alerts
  And I am on the new PR Tip page
  When I fill in "Message" with "Today is party day!"
  And I press "Save"
  Then "sam@example.com" should have no emails

@emails
  Scenario: New Announcement notification, user prefers emails
    Given "sam" prefers to receive direct message alerts
    And I am on the new PR Tip page
    When I fill in "Message" with "Today is party day!"
    And I press "Save"
    Then "sam@example.com" should have 1 email