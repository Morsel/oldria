@media @signup
Feature: Media accounts
  In order to make requests
  As a Journalist or other member of the media
  I want join RIA's "Mediafeed"

  Scenario: Sign up
    Given I am on the media user signup page
    When I sign up with:
      | username | email        | password | publication     |
      | jimbo    | jimbo@bo.com | secret   | Chicago Tribune |
    Then "jimbo@bo.com" should have 1 email
    And "jimbo" should be marked as a media user

  Scenario: Media layout
    Given a media user "mediaman" has just signed up
    When I confirm my account
    Then I should be on the dashboard
    
  Scenario: Logging in
    Given a media user "newsy" has just signed up
    And "newsy" has just been confirmed
    When I go to the login page
    Then I should see "Welcome to Spoonfeed"
  
  Scenario: Logging out
    Given a media user "journo" has just signed up
    And "journo" has just been confirmed
    And I am logged in as "journo"
    When I logout
    Then I should be on the homepage