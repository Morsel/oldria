@passwords @login
Feature: Reset password
  So that I can login
  As a user who has forgotten/lost my password
  I want to reset my password, with an email confirmation

  Scenario: Normal Reset Password Workflow
    Given the following confirmed user:
      | username | email       |
      | freddyb  | fred@me.com |

    When I am on the homepage
    And I follow "Login"
    And I fill in "Username" with "freddyb"
    And I fill in "Password" with "incorrect"
    And I press "Login"
    Then I should see "wrong username or password"
    And I should see "Forgot your password?"

    When I follow "Forgot your password?"
    Then I should be on the password reset request page

    When I fill in "Email" with "fred@me.com"
    And I press "Reset my password"

    Then I should see "Please check your email for instructions"
    Then "fred@me.com" should receive 1 email
    And "foo@bar.com" should receive no emails

    When "fred@me.com" opens the email with subject "SpoonFeed: Password Reset Instructions"
    Then I should see "reset" in the email body

    When I click the first link in the email
    Then I should see "Change My Password"

    When I fill in "New Password" with "newpassword"
    And I fill in "Confirm New Password" with "newpassword"
    And I press "Update my password and log me in"
    Then I should see "Password successfully updated"
    And "freddyb" should be logged in

  Scenario: Trying to reset when already logged in
    Given the following confirmed user:
      | username | password  |
      | james    | secret    |
    And I am logged in as "james" with password "secret"

    When I go to the password reset request page
    Then I should see "You must be logged out to access this page"

  Scenario: Trying to reset a non-existing account
    Given the following confirmed user:
      | username | email               |
      | correct  | correct@example.com |

    When I am on the password reset request page
    And I fill in "Email" with "noone@example.com"
    And I press "Reset my password"

    Then I should see "No user was found with that email address"

  Scenario: Trying to reset more than once
    Given the following confirmed user:
      | username | email               |
      | thatguy  | correct@example.com |

    And I am on the password reset request page

    When I fill in "Email" with "correct@example.com"
    And I press "Reset my password"
    Then "correct@example.com" should receive 1 email

    When "correct@example.com" opens the email with subject "SpoonFeed: Password Reset Instructions"
    And I click the first link in the email
    And I fill in "New Password" with "newpassword"
    And I fill in "Confirm New Password" with "newpassword"
    And I press "Update my password and log me in"
    Then I should see "Password successfully updated"
    And "thatguy" should be logged in

    When I logout
    And "correct@example.com" opens the email with subject "SpoonFeed: Password Reset Instructions"
    And I click the first link in the email
    Then I should see "Oops. We're having trouble finding your account."
