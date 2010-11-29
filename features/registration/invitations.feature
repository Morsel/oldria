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
    Then I should see "Thanks for recommending a new member"
    # And "ma@email.com" should have 1 email
    
  Scenario: an invite is approved and the user wants to log in and update their info (not a restaurant employee)
    Given there are the following invitations:
      | first_name  | last_name | email              |
      | Mariah      | Carpenter | mc@restaurants.com |
    Given a subject matter "Food"
    And I am logged in as an admin
    And I go to the admin invitations page
    And I follow "accept"
    Then "mariahcarpenter" should be a confirmed user
    # one invitation welcome message, one confirmation with log in link
    And "mc@restaurants.com" should have 2 emails

    When I logout
    And "mc@restaurants.com" opens the email with subject "Thanks for your interest in Spoonfeed!"
    Then they should see "Thanks, Ellen" in the email body
    
    When "mc@restaurants.com" opens the email with subject "SpoonFeed: You're invited"
    Then I should see an invitation URL in the email body
    
    When I click the first link in the email
    Then I should see "Successfully logged in"
    And I should be on the complete registration page
    
    When I fill in "Username" with "mcarpenter"
    And I fill in "Password" with "newpass"
    And I press "Next"
    Then I should see "must be accepted"
    And I should see "doesn't match confirmation"
    
    When I fill in "Username" with "mcarpenter"
    And I fill in "Password" with "newpass"
    And I fill in "Password confirmation" with "newpass"
    And I check "user_agree_to_contract"
    And I press "Next"
    Then I should see "Set up your profile details"
    
    When I fill in "Restaurant name" with "My Private Restaurant"
    And I select "Chef" from "Role"
    And I check "Food"
    And I check "user_default_employment_attributes_post_to_soapbox"

    And I fill in "Hometown" with "nowhere"
    And I fill in "Currently residing in" with "Seattle, WA"

    And I press "Save"
    Then I should see "Enjoy SpoonFeed!"
    And "mcarpenter" should have a primary employment
    
  Scenario: an invite is approved and the user wants to log in and update their info (invited as restaurant employee)
    Given a restaurant named "Restaurant du Jour" with manager "mgmtdujour"
    And a subject matter "Drink"
    And a restaurant role named "Beverage Director"
    
    Given there are the following invitations:
      | first_name  | last_name | email                 | restaurant_name    |
      | Maggie      | Davis     | davis@restaurants.com | Restaurant du Jour |
    And I am logged in as an admin
    And I go to the admin invitations page
    And I follow "accept"
    Then "maggiedavis" should be a confirmed user
    # one to confirm the invite was requested, one after approval
    And "davis@restaurants.com" should have 2 emails
    
    When I logout
    And "davis@restaurants.com" opens the email with subject "SpoonFeed: You're invited"
    Then I should see an invitation URL in the email body
    
    When I click the first link in the email
    Then I should see "Successfully logged in"
    And I should be on the complete registration page
    
    When I fill in "Username" with "mdavis"
    And I fill in "Password" with "newpass"
    And I fill in "Password confirmation" with "newpass"
    And I check "user_agree_to_contract"
    And I press "Next"
    Then I should see "Set up your profile details"
    # And I should see "Restaurant du Jour"
    # This is not passing because webrat hates me, but it does pre-fill in browser testing
    When I fill in "Restaurant name" with "Restaurant du Jour"
    
    When I select "Beverage Director" from "Role"
    And I check "Drink"
    And I fill in "Hometown" with "Ithaca, NY"
    And I fill in "Currently residing in" with "Palm Springs"
    And I press "Save"
    
    Then I should see "Is this your restaurant?"
    And "mdavis" should have a primary employment
    
    When I follow "Request to be added"
    Then I should see "We've contacted the restaurant manager."
    And "mgmtdujour@testsite.com" should have 1 email
