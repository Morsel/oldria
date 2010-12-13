@profile
Feature: Promotion sidebar for user
  Background:
  Given the following confirmed users:
    | username | email             | password |
    | admin    | admin@email.com   | secret   |
  And I am logged in as "admin"


  Scenario: User with basic accounte see promotion sidebar that reminds him that his profile is not on Soapbox. 
    Given the user "admin" does not have a premium account
    And I am on the profile page for "admin"
    Then I should see "Want media to see your profile?"

  Scenario: User with premium account should see "Display my profile on Soapbox" checkbox if not published yet 
    Given the user "admin" has a premium account
    And I am on the profile page for "admin"
    Then I should see "Display my profile on Soapbox"

  Scenario: User with premium account should see "Hide my profile on Soapbox" checkbox if already published
    Given the user "admin" has a premium account
    And "admin" has a published profile
    And I am on the profile page for "admin"
    Then I should see "Hide my profile on Soapbox"


