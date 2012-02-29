@media @signup
Feature: Media accounts
  In order to make requests
  As a Journalist or other member of the media
  I want join RIA's "Mediafeed"

  Scenario: Sign up
    Given I am on the join page
    When I fill in the following:
      | first_name | Jim          |
      | last_name  | Bo           |
      | email      | jimbo@bo.com |
      | role       | media        |
    And I press "submit"
    Then "jimbo@bo.com" should have 1 email
    And "JimBo" should be marked as a media user

  Scenario: Media confirmation
    Given a media user named "mediaman" has just signed up
    When I confirm my account
    And I fill in "Affiliated Publication" with "Sky News"
    And I check "user_national"
    And I fill in "Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I press "confirm"
    Then I should be on the dashboard
    And I should see "Welcome aboard!"
    
  Scenario: Logging in
    Given a media user named "newsy" has just signed up
    And "newsy" has just been confirmed
    When I go to the login page
    Then I should see "Welcome to Spoonfeed"
  
  Scenario: Logging out
    Given a media user named "journo" has just signed up
    And "journo" has just been confirmed
    And I am logged in as "journo"
	Then I should see "Fresh from Spoonfeed"
    When I logout
    Then I should be on the homepage