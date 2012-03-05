@profile
Feature: Promotion sidebar for user
  Background:
  Given the following confirmed users:
    | username | email             | password |
    | user1    | user1@email.com   | secret   |
  And I am logged in as "user1"

  Scenario: User with a basic account sees the promotion sidebar with a reminder that their profile is public
    Given the user "user1" does not have a premium account
    And I am on the profile page for "user1"
    Then I should see "upgrade" within "#user_status"

  # Scenario: User with premium account should see "Display my profile on Soapbox" checkbox if not published yet 
  #   Given the user "user1" has a premium account
  #   And "user1" does not have a published profile
  #   And I am on the profile page for "user1"
  #   Then I should see "Display my profile on Soapbox"

  # Scenario: User with premium account should see "Hide my profile on Soapbox" checkbox if already published
  #   Given the user "user1" has a premium account
  #   And "user1" has a published profile
  #   And I am on the profile page for "user1"
  #   Then I should see "Hide my profile on Soapbox"


