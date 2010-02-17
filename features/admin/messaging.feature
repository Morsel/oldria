@admin @messaging
Feature: Admin Messaging


  Background:
  Given a restaurant named "No Man's Land" with the following employees:
    | username | name      | role      | subject matters |
    | johndoe  | John Doe  | Chef      | Food, Pastry    |

@focus
  Scenario: Create a new Announcement
    Given I am logged in as "johndoe"
    And "johndoe" has a QOTD message with:
      | message | Are lazy cakes cool? |
    When I go to the dashboard
    And I follow "QOTD"
    Then I should see "Are lazy cakes cool?"

    When I fill in "Reply" with "Why, yes, they are quite cool!"
    And I press "Send"
    Then I should see "Why, yes, they are quite cool!"
    And I should see "Successfully created"

