@soapbox
Feature: Soapbox
  So that viewers can read through the members' profiles
  As a public user of the site
  I want to see a list of all relevant members
  
  Background:
    Given a restaurant named "Avec" with the following employees:
      | username | password | email            | name      | role      |
      | mgmt     | secret   | mgmt@example.com | Mgmt Joe  | Manager   |
      | bob      | secret   | bob@example.com  | Chef Bob  | Chef      |
      | chris    | secret   | chr@example.com  | Chris Xu  | Assistant |
    And "mgmt" has a complimentary premium account
    And "bob" has a complimentary premium account
    # "chris" does not have a premium account
    
    Given I am logged in as "mgmt"
  
    Given I am not logged in
    And I am logged in as "chris"
  
    # "bob" has not logged in yet
  
  Scenario: Featuring a QOTD on the soapbox
    Given I am not logged in
    And I go to the soapbox directory page
    Then I should see "Mgmt Joe"
    And I should not see "Chef Bob"
    And I should not see "Chris Xu"
