@invitations
Feature: users can be invited to join Spoonfeed by registered SF users, restaurant admins, or by requesting an invite as a public Soapbox user

  Background:
  Given a restaurant named "Jack's Diner" with the following employees:
    | username | password | email            | name           | role      |
    | mgmt     | secret   | mgmt@example.com | Mgmt Jack      | Manager   |
    | sam      | secret   | sam@example.com  | Samantha Smith | Chef      |
  And I am logged in as "sam"

  Scenario: a regular restaurant employee wants to invite a friend
    Given I am on the new invitation page
    And I fill in "First name" with "Mary Anne"
    And I fill in "Email" with "ma@email.com"
    And I press "Invite User"
    Then I should see "Your invite has been sent to an admin for approval"
