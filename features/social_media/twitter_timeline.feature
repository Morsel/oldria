Feature: Twitter Authentication
  So that I can read my twitter timeline without having to go over there, 
  As a SF member and twitter member, 
  I want to see my Twitter timeline from within SF.


  Scenario: Add Twitter account to SpoonFeed Profile
    Given the following confirmed user:
    | username | password |
    | johnny   | secret   |
    And I am logged in as "johnny" with password "secret"
    When I go to the homepage
    And I follow "Setup Twitter"
    And Twitter authorizes "johnny"
    Then I should see "Latest Tweets"
    And I should not see "Setup Twitter"


  Scenario: Viewing Friends Timeline
    Given the following confirmed, twitter-authorized user:
    | username | password |
    | stevie   | secret   |
    Given I am logged in as "stevie" with password "secret"
    And I am on the homepage
    When I follow "Latest Tweets"

    ## From a fixture file ##
    Then I should see "Best American flag etiquette video series I've seen all month!"
    And the first tweet should have a link

