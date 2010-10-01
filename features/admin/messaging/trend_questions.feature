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

    Given I am logged in as "sam" with password "secret"
    When I go to my inbox
    Then I should see "Chefs only"

    Given I am logged in as "jim" with password "secret"
    When I go to my inbox
    Then I should not see "Chefs only"


  Scenario: Managers can see all the restaurant's trend questions
    Given "sam" is the account manager for "Normal Pants"
    Given I am logged in as an admin
    When I create a new trend question with subject "Assistants only" with criteria:
      | Role | Assistant |
    Then the trend question with subject "Assistants only" should have 1 restaurant
    And the last trend question for "Normal Pants" should be viewable by "Jim Smith"
    And the last trend question for "Normal Pants" should be viewable by "Sam Smith"

  Scenario: Restaurant folks can respond to trend questions
    Given I am logged in as an admin
    When I create a new trend question with subject "My river runs blue" with criteria:
      | Region | Midwest (IN IL OH) |
  
    Given I am logged in as "sam" with password "secret"
    And I go to the RIA messages page
    Then I should see "My river runs blue"
  
    When I follow "Post"
    And I fill in "Post" with "But my river is green"
    And I press "Send"
    Then the discussion for the trend question with subject "My river runs blue" should have 1 comment

  Scenario: A user can edit their trend question comment
    Given I am logged in as an admin
    When I create a new trend question with subject "Microbiology!" with criteria:
      | Region | Midwest (IN IL OH) |
    And trend question "Microbiology!" has a reply "Really?" by "sam"
    
    Given I am logged in as "sam" with password "secret"
    And I go to the RIA messages page
    And I follow "View your post"
    And I follow "Edit" within "div.comments"
    And I fill in "Comment" with "Yes! It is green."
    And I press "Save Comment"
    Then I should see "Updated comment"

  Scenario: Displaying saved criteria
    Given I am logged in as an admin
    When I create a new trend question with subject "Favorite colors" with criteria:
      | Region | Midwest (IN IL OH) |
    Then I should see "Region: Midwest"
    When I go to the list of trend questions
    Then I should see "Region: Midwest"

@emails
  Scenario: New Trend Question notification, user prefers no emails
    Given I am logged in as an admin
    When I create a new trend question with subject "Chef Surprise" with criteria:
      | Region | Midwest (IN IL OH) |
      | Role   | Chef               |
    Then the trend question with subject "Chef Surprise" should have 1 restaurant
    And the last trend question for "Normal Pants" should be viewable by "Sam Smith"
    And "sam@example.com" should have no emails

@emails
  Scenario: New Trend Question notification, user prefers emails
    Given "sam" prefers to receive direct message alerts
    Given I am logged in as an admin
    When I create a new trend question with subject "Chef Surprise" with criteria:
      | Region | Midwest (IN IL OH) |
      | Role   | Chef               |
    Then the trend question with subject "Chef Surprise" should have 1 restaurant
    And the last trend question for "Normal Pants" should be viewable by "Sam Smith"
    And "sam@example.com" should have 1 email

    Given "jim" is the account manager for "Normal Pants"
    And I am logged in as "jim" with password "secret"
    When I go to my inbox
    And I follow "Post"
    And I fill in "Post" with "But my river is green"
    And I press "Send"
    
    Then "sam@example.com" should have 2 emails
    
