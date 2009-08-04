Feature: Reset password
  So that I can login
  As a user who has forgotten/lost my password
  I want to reset my password, with an email confirmation

@focus
  Scenario: Normal Reset Password Workflow
    Given the following confirmed user:
    | username | email       |
    | freddy   | fred@me.com |

    When I am on the homepage
    And I follow "Login"
    And I fill in "Username" with "freddy"
    And I fill in "Password" with "incorrect"
    And I press "Submit"
    Then I should see "couldn't log you in"
    And I should see "Forgot your password?"

    When I follow "Forgot your password?"
    Then I should be on the password reset request page

    When I fill in "Email" with "fred@me.com"
    And I press "Reset my password"

    Then I should see "Please check your email for instructions"
    Then "fred@me.com" should receive 1 email
    And "foo@bar.com" should not receive an email

    When "fred@me.com" opens the email with subject "SpoonFeed: Password Reset Instructions"
    Then I should see "reset" in the email
    
    When I click the first link in the email
    Then I should see "Change My Password"
    And "freddy" should not be logged in
    
    When I fill in "New Password" with "newpassword"
    And I fill in "Confirm New Password" with "newpassword"
    And I press "Update my password and log me in"
    Then I should see "Password successfully updated"
    And "freddy" should be logged in
