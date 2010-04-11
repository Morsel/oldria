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
      | jim      | secret   | jim@example.com  | Jim Smith | Assistant | Beer            |
    Given a restaurant named "Fancy Lamb" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    And the restaurant "Normal Pants" is in the region "Midwest"
    And the restaurant "Fancy Lamb" is in the region "Southwest"



  Scenario: New Trend Question
    Given I am logged in as an admin
    When I create a new trend question with subject "Where's the beef?" with criteria:
      | Region | Midwest (IN IL OH) |
    Then the trend question with subject "Where's the beef?" should have 1 restaurant
    And "Normal Pants" should have 1 new trend question
    But "Fancy Lamb" should not have any trend questions


  Scenario: New Restaurants that fit criteria should be added
    Given I am logged in as an admin
    When I create a new trend question with subject "Are Cucumbers tasty?" with criteria:
      | Region | Midwest (IN IL OH) |
    Then the trend question with subject "Are Cucumbers tasty?" should have 1 restaurant

    Given a restaurant named "Newbie McGee" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | guy      | secret   | guy@example.com  | Guy Jones | Chef      | Food            |
    And the restaurant "Newbie McGee" is in the region "Midwest"
    Then the trend question with subject "Are Cucumbers tasty?" should have 2 restaurants


  Scenario: Only applicable employees can see the trend question
    Given I am logged in as an admin
    When I create a new trend question with subject "Chefs only" with criteria:
      | Role | Chef |
    Then the trend question with subject "Chefs only" should have 1 restaurant
    And the last trend question for "Normal Pants" should be viewable by "Sam Smith"
    But the last trend question for "Normal Pants" should not be viewable by "Jim Smith"
