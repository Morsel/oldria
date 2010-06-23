@login
Feature: Users login with username or email address
  So that I can easily log in, 
  As a user who forgot my username but knows my email address and password,
  I should be able to log in using either my email address or my username.

  Background:
    Given the following confirmed user:
    | username | email          | password |
    | jimmy12  | jimmy@dean.com | secret   |
    And the following unconfirmed user:
    | username | email           | password |
    | jimmy13  | jimmy@deanx.com | secret   |


  Scenario: Logging in with email
    Given I am on the login page
    When I fill in "Username" with "jimmy@dean.com"
    And I fill in "Password" with "secret"
    And I press "Login"
    Then I should see "You are now logged in."

  Scenario: Logging in with username
    Given I am on the login page
    When I fill in "Username" with "jimmy12"
    And I fill in "Password" with "secret"
    And I press "Login"
    Then I should see "You are now logged in."
    
  Scenario: Logging in with invalid password
    Given I am on the login page
    When I fill in "Username" with "jimmy12"
    And I fill in "Password" with "wrongness"
    And I press "Login"
    Then I should see "wrong username or password"

    Scenario: Logging in with unconfirmed account
      Given I am on the login page
      When I fill in "Username" with "jimmy13"
      And I fill in "Password" with "secret"
      And I press "Login"
      Then I should see "Your account is not confirmed."
