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
    And I fill in "Last name" with "Smith"
    And I fill in "Email" with "ma@email.com"
    And I press "Invite User"
    Then I should see "Your invite has been sent to an admin for approval"
    
  Scenario: an invite is approved and the user wants to log in and update their info
    Given there are the following invitations:
      | first_name  | last_name | email              |
      | Mariah      | Carpenter | mc@restaurants.com |
    And I am logged in as an admin
    And I go to the admin invitations page
    And I follow "accept"
    Then "mariahcarpenter" should be a confirmed user
    And "mc@restaurants.com" should have 1 email
    
    When I logout
    And "mc@restaurants.com" opens the email with subject "SpoonFeed: You're invited"
    Then I should see an invitation URL in the email body
    
    When I click the first link in the email
    Then I should see "Successfully logged in"
    And I should be on the complete registration page
    
    When I fill in "Username" with "mcarpenter"
    And I fill in "Password" with "newpass"
    And I press "Save"
    Then I should see "must be accepted"
    And I should see "doesn't match confirmation"
    
    When I fill in "Username" with "mcarpenter"
    And I fill in "Password" with "newpass"
    And I fill in "Password confirmation" with "newpass"
    And I check "user_agree_to_contract"
    And I press "Save"
    Then I should see "Enjoy SpoonFeed!"
