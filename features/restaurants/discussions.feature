@discussions @restaurants
Feature: Discussions
  In order to increase communication among my team
  As a Restaurant professional
  I want to invite fellow Restaurant Employees to have discussions, where I can post a topic, and have people from my restaurant respond as comments to that post.

  Background:
    Given there are no discussions
    Given a restaurant named "Arabian Nights" with the following employees:
      | username | password | email            | name      | role      |
      | wendy    | secret   | wsue@example.com | Wendy Sue | Manager   |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      |
      | john     | secret   | john@example.com | John Doe  | Sommelier |


  Scenario: Create a new Discussion
    Given I am logged in as "sam" with password "secret"
    When I follow "read my messages"
    And I follow "Discussions"
    And I follow "New Staff Discussion"
    And I fill in "Subject" with "Where should we eat?"
    And I check "Wendy Sue"
    And I press "Post Discussion"
    Then there should be 1 discussion in the system


  Scenario: Discussion notifications
    Given I am logged in as "sam" with password "secret"
    When I follow "read my messages"
    And I follow "Discussions"
    And I follow "New Staff Discussion"
    And I fill in "Subject" with "Where should we eat?"
    And I check "Wendy Sue"
    And I uncheck "John Doe"
    And I press "Post Discussion"
    Then "wsue@example.com" should have 1 email
    And "john@example.com" should have no emails

    When "wsue@example.com" opens the email with subject "Spoonfeed: Sam Smith has invited you to a discussion"
    And I follow "View this discussion" in the email
    Then I should see "Where should we eat?"


  Scenario: Commenting on a Discussion
    Given I am logged in as "wendy" with password "secret"
    And I have just posted a discussion with the title "Lets go to the movies"
    When I visit that discussion
    And I fill in "Comment" with "Sounds like a plan"
    And I press "Post Comment"
    Then I should see "your answer has been saved"
    And I should see "Lets go to the movies"
    And I should see "Sounds like a plan"


@allow-rescue
  Scenario: Lockdown
    Given I am logged in as "sam" with password "secret"
    When I follow "read my messages"
    And I follow "Discussions"
    And I follow "New Staff Discussion"
	And I fill in "Subject" with "Where should we eat?"
	And I check "Wendy Sue"
	And I uncheck "John Doe"
	And I press "Post Discussion"
    Then there should be 1 discussion in the system

    Given I am logged in as "john" with password "secret"
    And I visit that discussion
    Then I should see "content you are trying to view is not available to your user account"
    And I should not see "Where should we eat?"
