Feature: Create an Account
  So that I can improve my social media networking/marketing
  As a prospective RIA client that is not a journalist, 
  I want to create a free SF account.


  Scenario: Brand New account signup
    Given there are no users
    When I am on the signup page
    Then I should see "Sign up for SpoonFeed"

    When I fill in "Username" with "janet"
    And I fill in "Email" with "jparker@example.com"
    And I fill in "Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I press "Submit"

    Then "jparker@example.com" should receive 1 email
    And "jparker@example.com" should have 1 email
    And "foo@bar.com" should not receive an email

    When "jparker@example.com" opens the email with subject "Welcome to SpoonFeed! Please confirm your account"

    Then I should see "confirm" in the email
    And I should see "janet" in the email

    When I follow "Click here to confirm your account!" in the email
    Then I should see "Thanks. You are now confirmed, janet"
    And "janet" should be a confirmed user
    And "janet" should be logged in
    And I should see "You are now logged in"


  Scenario: Bad email
    Given there are no users
    When I am on the signup page
    Then I should see "Sign up for SpoonFeed"

    When I fill in "Username" with "janet"
    And I fill in "Email" with "janet"
    And I fill in "Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I press "Submit"
    
    Then I should see "Email should look like an email address"
    
  Scenario: Email already taken
    Given the following confirmed user:
    | username | password | email |
    | jimjames | secret   | jimjames@example.com |

    When I am on the signup page
    And I fill in "Username" with "jimmyboy"
    And I fill in "Email" with "jimjames@example.com"
    And I fill in "Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I press "Submit"
    
    Then I should see "Email has already been taken"


  Scenario: Attempting to Log in before confirmed
    Given there are no users
    When I am on the signup page
    And I fill in "Username" with "jimbob"
    And I fill in "Email" with "jimbob@example.com"
    And I fill in "Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I press "Submit"
    Then "jimbob@example.com" should receive 1 email

    When I am on the login page
    And I fill in "Username" with "jimbob"
    And I fill in "Password" with "secret"
    And I press "Submit"

    Then I should see "Your account is not confirmed"
    And "jimbob" should not be logged in


  Scenario: Logging in
    Given the following confirmed user:
    | username | password |
    | mistered | secret   |

    When I am on the homepage
    And I follow "Login"
    And I fill in "Username" with "mistered"
    And I fill in "Password" with "secret"
    And I press "Submit"

    Then I should see "Successfully logged in"


  Scenario: Attempting to Log in with incorrect password
     Given the following confirmed user:
      | username | password |
      | mistered | secret   |
    When I am on the login page
    And I fill in "Username" with "mistered"
    And I fill in "Password" with "blue"
    And I press "Submit"
    Then I should see "we couldn't log you in"


  Scenario: Logging Out
    Given the following confirmed user:
    | username | password |
    | shelly   | secret   |
    And I am logged in as "shelly" with password "secret"
    And I am on the homepage
    When I follow "Log out"
    Then I should see "Successfully logged out"

