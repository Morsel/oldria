@profile
Feature: Update information
  So that I can change my twitter account, my name, or other details about my account,
  As a SF member,
  I should be able to update my account profile.

  Scenario: Update my username
    Given the following user records:
    | username | password |
    | lestor   | secret   |
    And I am logged in as "lestor" with password "secret"
    When I follow "My Profile"
    And I fill in "Username" with "leslie"
    And I press "Save"
    Then I should see "Successfully updated your profile"

  Scenario: Updating password
    Given the following user records:
    | username | password |
    | manny    | secret   |
    And I am logged in as "manny" with password "secret"
    When I follow "My Profile"
    And I fill in "Password" with "betterpassword"
    And I fill in "Password Confirmation" with "betterpassword"
    And I press "Save"
    Then I should see "Successfully updated your profile"

    When I am on the login page
    And I fill in "Username" with "manny"
    And I fill in "Password" with "betterpassword"
    And I press "Login"

    Then I should see "You are now logged in"


  Scenario: Require matching password/confirmation to update
    Given the following user records:
    | username | password |
    | horatio  | secret   |
    And I am logged in as "horatio" with password "secret"
    When I follow "My Profile"
    And I fill in "Password" with "betterpassword"
    And I fill in "Password Confirmation" with "better"
    And I press "Save"
    Then I should see "doesn't match confirmation"

@twitter
  Scenario: Removing Twitter
    Given the following confirmed, twitter-authorized users:
    | username | password |
    | sammy    | secret   |
    And I am logged in as "sammy" with password "secret"
    When I follow "My Profile"
    And I follow "Disconnect Twitter"
    Then I should see "Your Twitter Account was disassociated with your SpoonFeed Account"
    And "sammy" should not have Twitter linked to his account
    And I should not see "Remove Twitter Information"


  Scenario: Users cannot edit other users' accounts
    Given the following confirmed, twitter-authorized users:
    | username | password |
    | angel    | secret   |
    | devil    | demon    |
    And I am logged in as "devil" with password "demon"
    When I go to the edit page for "angel"
    Then I should see "This is an administrative area"
    And I should be on the homepage
