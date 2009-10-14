Feature: Media accounts
  In order to make requests
  As a Journalist or other member of the media
  I want join RIA's "Media Feed"


  Scenario: Sign up
    Given I am on the media user signup page
    When I sign up with:
      | username | email        | password | publication     |
      | jimbo    | jimbo@bo.com | secret   | Chicago Tribune |
    Then "jimbo@bo.com" should have 1 email
    And "jimbo" should be marked as a media user


