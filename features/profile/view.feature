@profile
Feature: Profile View
  Background:
  Given the following confirmed users:
    | username | email             | password |
    | admin    | admin@email.com   | secret   |

  Scenario: User with basic account cant see "Display my profile on Soapbox" checkbox 
    Given the user "admin" does not have a premium account
    And I am logged in as "admin"
    And I am on the profile page for "admin"
    And I follow "EDIT PROFILE"
    Then I should see "Summary"
    And I should not see "Display my profile on Soapbox"

  Scenario: User with premium account should see "Display my profile on Soapbox" checkbox 
    Given the user "admin" has a premium account
    And I am logged in as "admin"
    And I am on the profile page for "admin"
    And I follow "EDIT PROFILE"
    Then I should see "Summary"
    And I should see "Display my profile on Soapbox"

