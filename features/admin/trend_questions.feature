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


  Scenario: Managers can see all the restaurant's trend questions
    Given "sam" is the account manager for "Normal Pants"
    Given I am logged in as an admin
    When I create a new trend question with subject "Assistants only" with criteria:
      | Role | Assistant |
    Then the trend question with subject "Assistants only" should have 1 restaurant
    And the last trend question for "Normal Pants" should be viewable by "Jim Smith"
    And the last trend question for "Normal Pants" should be viewable by "Sam Smith"

@focus
  Scenario: Restaurant folks can respond to trend questions
    Given I am logged in as an admin
    When I create a new trend question with subject "My river runs blue" with criteria:
      | Region | Midwest (IN IL OH) |

    Given I am logged in as "sam" with password "secret"
    And I go to the RIA messages page
    Then I should see "My river runs blue"

    When I follow "Reply"
    And I fill in "Reply" with "But my river is green"
    And I press "Send"
    Then I should see "Successfully created"
