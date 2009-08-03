Feature: Create an Account
  So that I can improve my social media networking/marketing
  As a prospective RIA client that is not a journalist, 
  I want to create a free SF account.


  Scenario: Brand New account
    Given there are no users
    When I am on the signup page
    Then I should see "Sign up for SpoonFeed"

    When I fill in "Username" with "Janet Parker"
    And I fill in "Email" with "jparker@example.com"
    And I fill in "Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I press "Submit"

    Then I should see "Registration successful"


  Scenario: Logging in
    Given the following user:
    | username | password |
    | mistered | secret   |

    When I am on the homepage
    And I follow "Login"
    And I fill in "Username" with "mistered"
    And I fill in "Password" with "secret"
    And I press "Submit"

    Then I should see "Successfully logged in"


  Scenario: Logging Out
    Given the following user:
    | username | password |
    | shelly   | secret   |
    And I am logged in as "shelly" with password "secret"
    And I am on the homepage
    When I follow "Log out"
    Then I should see "Successfully logged out"

