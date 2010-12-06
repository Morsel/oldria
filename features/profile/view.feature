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
    And I follow "Share"
    Then I should be on the new subscription page for "admin"  

