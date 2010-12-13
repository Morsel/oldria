@profile
Feature: Profile View
  Background:
  Given the following confirmed users:
    | username | email             | password |
    | admin    | admin@email.com   | secret   |

  Scenario: User with basic account can't share profile
    Given the user "admin" does not have a premium account
    And I am logged in as "admin"
    And I am on the profile page for "admin"
    Then I can`t share this profile
    
  Scenario: User with premium account can share profile
    Given the user "admin" has a premium account
    And I am logged in as "admin"
    And I am on the profile page for "admin"
    Then I should see addThis button

  Scenario: User with basic account cant see "Display my profile on Soapbox" checkbox 
    Given the user "admin" does not have a premium account
    And I am logged in as "admin"
    And I am on the profile page for "admin"
    And I follow "EDIT PROFILE"
    Then I should see "Profile Summary"
    And I should not see "Display my profile on Soapbox"

  Scenario: User with premium account should see "Display my profile on Soapbox" checkbox 
    Given the user "admin" has a premium account
    And I am logged in as "admin"
    And I am on the profile page for "admin"
    And I follow "EDIT PROFILE"
    Then I should see "Profile Summary"
    And I should see "Display my profile on Soapbox"

  Scenario: User with basic accounte see promotion sidebar that reminds him that his profile is not on Soapbox. 
    Given the user "admin" does not have a premium account
    And I am logged in as "admin"
    And I am on the profile page for "admin"
    Then I should see "Want media to see your profile?"

  Scenario: User with premium account should see "Display my profile on Soapbox" checkbox if not published yet 
    Given the user "admin" has a premium account
    And I am logged in as "admin"
    And I am on the profile page for "admin"
    Then I should see "Display my profile on Soapbox"

  Scenario: User with premium account should see "Hide my profile on Soapbox" checkbox if already published
    Given the user "admin" has a premium account
    And I am logged in as "admin"
    And "admin" has a published profile
    And I am on the profile page for "admin"
    Then I should see "Hide my profile on Soapbox"



