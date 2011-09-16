@frontburner
Feature: Reading Front Burner posts
  
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

  Scenario: Individual users who don't have a primary employment should get a help message
    Given I am logged in as "neue" with password "secret"
    When I go to Front Burner
    And I should see "In order to receive Front Burner questions, please make sure your role and areas of expertise are set up in your profile summary"
