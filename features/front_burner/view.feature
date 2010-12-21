@frontburner
Feature: Frontburner page
  
  Background:
    Given a restaurant named "Normal Pants" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | jim      | secret   | jim@example.com  | Jim Smith | Assistant | Beer            |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
    And the restaurant "Normal Pants" is in the region "Midwest"
    Given the following confirmed user:
      | username | first_name | last_name | email         |
      | neue     | Neue       | User      | neue@mail.com |
      | luk      | Luk        | User      | luk@mail.com  |
    And "luk" has a default employment with role "Baker" and restaurant name "bbc"


  Scenario: Individual users who dont have permissions to answer qotd/trend question should get help message
    Given I am logged in as "neue" with password "secret"
    When I go to Front Burner
    And I should see "In order to receive Front Burner questions, please make sure your role and subject matter are set up in your profile summary"

  Scenario: Individual users who have permissions to answer qotd/trend question should not get help message
    Given I am logged in as "luk" with password "secret"
    When I go to Front Burner
    And I should not see "In order to receive Front Burner questions, please make sure your role and subject matter are set up in your profile summary"

  Scenario: Restaurant users who dont have permissions to answer qotd/trend question should get help message
    Given I am logged in as an admin
    And "jim" is not allowed to post to soapbox
    And I am logged in as "jim" with password "secret"
    When I go to Front Burner
    And I should see "Sorry, your account currently isn't set to receive Front Burner questions"
    
  Scenario: Restaurant users who have permissions to answer qotd/trend question should not get help message
    When I am logged in as "sam" with password "secret"
    When I go to Front Burner
    And I should not see "Sorry, your account currently isn't set to receive Front Burner questions"

