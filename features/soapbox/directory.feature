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

    And "mgmt" has a published profile
    And "chris" has a published profile
<<<<<<< HEAD
  
  Scenario: Viewing users in the directory
=======

  Scenario: Featuring a QOTD on the soapbox
>>>>>>> 0d885de0232c39edf669051605144e91740fac7d
    Given I am not logged in
    When I go to the soapbox directory page
    Then I should see "Mgmt Joe"
    And I should not see "Chef Bob"
    And I should not see "Chris Xu"

  Scenario: Searching for solo users
    Given the following confirmed user:
      | username | password | email      | name            |
      | annalena | secret   | a@aqua.com | Annalena Kruger |
    And "annalena" has a default employment with role "Executive Chef" and restaurant name "Aquavit"
    And "annalena" has a complimentary premium account
    And "annalena" has a published profile
    And I am logged in as "annalena"
    When I go to the soapbox directory page
    Then I should see "Aquavit"
    And I should see "Annalena"
    When I check "Aquavit"
    Then I should see "Annalena" within "#user-results"

@addthis
  Scenario: Viewing addThis on user profiles
    Given the following published users:
      | username    | password |
      | punkrock    | secret   |
    And "punkrock" has a default employment with role "Executive Chef" and restaurant name "Aquavit"
    And "punkrock" has a complimentary premium account
    And I go to the soapbox profile page for "punkrock"
    Then I should see addThis button
