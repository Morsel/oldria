@trendquestion @admin @messaging
Feature: Trend questions
  So that everyone in a restaurant group can see what other users have done
  As a restauranteur
  I want to see all restaurant correspondence on some types of Admin messages

  These previously worked as staff-to-individual messages.
  Now they are staff-to-restaurant based. (They will work just like restaurant conversations.)

  Background:
    Given the following restaurant records:
      | name         | city        | state |
      | Normal Pants | Chicago     | IL    |
      | Fancy Lamb   | San Antonio | TX    |
    And the restaurant "Normal Pants" is in the region "Midwest"
    And the restaurant "Fancy Lamb" is in the region "Soutwest"


  Scenario: New Trend Question
    Given I am logged in as an admin
    When I create a new trend question with subject "Where's the beef?" with criteria:
      | James Beard Region | Midwest |
    Then "Normal Pants" should have 1 new trend question
    But "Fancy Lamb" should not have any new trend question

