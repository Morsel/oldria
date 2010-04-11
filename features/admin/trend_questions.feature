@trendquestion @admin @messaging
Feature: Trend questions
  So that everyone in a restaurant group can see what other users have done
  As a restauranteur
  I want to see all restaurant correspondence on some types of Admin messages

  These previously worked as staff-to-individual messages.
  Now they are staff-to-restaurant based. (They will work just like restaurant conversations.)


  Background:
    Given a restaurant named "Normal Pants" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
    Given a restaurant named "Fancy Lamb" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    And the restaurant "Normal Pants" is in the region "Midwest"
    And the restaurant "Fancy Lamb" is in the region "Southwest"



  Scenario: New Trend Question
    Given I am logged in as an admin
    When I go to the new trend question page
    # Then show me the page
    When I create a new trend question with subject "Where's the beef?" with criteria:
      | Region | Midwest (IN IL OH) |
    Then the trend question with subject "Where's the beef?" should have 1 restaurant
    And "Normal Pants" should have 1 new trend question
    But "Fancy Lamb" should not have any trend questions

