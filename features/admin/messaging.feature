@admin @messaging
Feature: Admin Messaging

  Background:
  Given a restaurant named "No Man's Land" with the following employees:
    | username | name      | role      | subject matters |
    | johndoe  | John Doe  | Chef      | Food, Pastry    |


  Scenario: Replying to a QOTD
    Given I am logged in as "johndoe"
    And "johndoe" has a QOTD message with:
      | message | Are lazy cakes cool? |
    When I go to the dashboard
    And I follow "Question of the Day"
    Then I should see "Are lazy cakes cool?"

    When I fill in "Reply" with "Why, yes, they are quite cool!"
    And I press "Send"
    Then I should see "Why, yes, they are quite cool!"
    And I should see "Successfully created"


  Scenario: PR Tips have no replies
    Given I am logged in as "johndoe"
    And "johndoe" has a PR Tip message with:
      | message | Never burn a burn notice |
    When I go to the dashboard
    And I follow "PR Tip"
    Then I should see "Never burn a burn notice"
    But I should not see "Reply"


  Scenario: Admin Messages can be scheduled
    Given I am logged in as "johndoe"
    And "johndoe" has a PR Tip message with:
      | message      | This is a scheduled message |
      | scheduled_at | 2010-06-04 11:30:00         |
    When I go to the dashboard
    Then I should not see "PR Tip"

    When the date and time is "2010-06-04 11:45:00"
    And I go to the dashboard
    And I follow "PR Tip"
    Then I should see "This is a scheduled message"
    But I should not see "Reply"
