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

  Scenario: Solo Employments that fit criteria should be included
    Given the following confirmed user:
      | username | first_name | last_name | email         |
      | neue     | Neue       | User      | neue@mail.com |
    And "neue" has a default employment with the role "Baker"
    And "neue" prefers to receive direct message alerts
    And I am logged in as an admin

    When I create a new trend question with subject "What did you have for breakfast?" with criteria:
      | Role | Baker |
    Then the trend question with subject "What did you have for breakfast?" should have 1 solo employment
    And "neue@mail.com" should receive 1 email

  Scenario: Only applicable employees can see the trend question
    Given I am logged in as an admin
    When I create a new trend question with subject "Chefs only" with criteria:
      | Role | Chef |
    Then the trend question with subject "Chefs only" should have 1 restaurant
    And the last trend question for "Normal Pants" should be viewable by "Sam Smith"
    But the last trend question for "Normal Pants" should not be viewable by "Jim Smith"

    Given I am logged in as "sam" with password "secret"
    When I go to Front Burner
    Then I should see "Chefs only"

    Given I am logged in as "jim" with password "secret"
    When I go to Front Burner
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
    When I go to Front Burner
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
    When I go to Front Burner
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
    
  Scenario: A user who is not with a restaurant can receive trend questions
    Given the following confirmed users:
      | username | email           | first_name | last_name |
      | amy      | amy@example.com | Amy        | Testuser  |
    And "amy" has a default employment with the role "Executive Chef"
    And I am logged in as an admin

    When I create a new trend question with subject "More chefs only" with criteria:
      | Role | Executive Chef |
    Then I should see "Amy Testuser"

    Given I am logged in as "amy" with password "secret"
    When I go to Front Burner
    Then I should see "More chefs only"

    When I follow "Post"
    And I fill in "Post" with "Polo!"
    And I press "Send"
    Then the discussion for the trend question with subject "More chefs only" should have 1 comment

@emails
  Scenario: New Trend Question notification, user prefers no emails
    Given I am logged in as an admin
    And "sam" prefers to not receive direct message alerts
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
    When I go to Front Burner
    And I follow "Post"
    And I fill in "Post" with "But my river is green"
    And I press "Send"
    
    Then "sam@example.com" should have 2 emails

@emails
  Scenario: New Trend Question notification, user has set a notification email address
    Given "sam" prefers to receive direct message alerts
    And "sam" has set a notification email address "assistant@myrestaurant.com"
    Given I am logged in as an admin
    When I create a new trend question with subject "Chef Surprise" with criteria:
      | Region | Midwest (IN IL OH) |
      | Role   | Chef               |
    Then the trend question with subject "Chef Surprise" should have 1 restaurant
    And the last trend question for "Normal Pants" should be viewable by "Sam Smith"
    And "assistant@myrestaurant.com" should have 1 email
