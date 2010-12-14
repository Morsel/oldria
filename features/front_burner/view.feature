@frontburner
Feature: Frontburner page
  
  Background:
    Given a restaurant named "Normal Pants" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | jim      | secret   | jim@example.com  | Jim Smith | Assistant | Beer            |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
    And the restaurant "Normal Pants" is in the region "Midwest"

  Scenario: Users who dont have permissions to answer qotd/trend question should get help message
    Given I am logged in as an admin
    And "jim" is not allowed to post to soapbox
    And I am logged in as "jim" with password "secret"
    When I go to Front Burner
    And I should see "Sorry, your account currently isn't set to receive Front Burner questions"
    When I am logged in as "sam" with password "secret"
    When I go to Front Burner
    And I should not see "Sorry, your account currently isn't set to receive Front Burner questions"

