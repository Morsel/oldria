@alm @restaurant
Feature: Manage a_la_minutes
  In order to provide current information for our users
  Our restaurant managers and employees
  wants to be able to answer a la minute questions

  Background:
    Given a restaurant named "Steak Knife"
    And that "Steak Knife" has a premium account
    And that "Steak Knife" has an employee "stoneh"
    And I am logged in as "stoneh"

  Scenario: Questions are displayed for a manager
    Given the following a la minute questions:
      | question                                      |
      | What's the newest item on your menu?          |
      | What music is playing in your kitchen?        |
    When I go to the edit a la minute question page for "Steak Knife"
    Then I see a header for a la minute
    And I see the text for each question

  Scenario: Answers for each question are displayed
    And "Steak Knife" has answered the following A La Minute questions:
     | question        | answer         |
     | What's new?     | Lobster Bisque |

    When I go to the edit a la minute question page for "Steak Knife"
    Then I should see the answer "Lobster Bisque"

  Scenario: Only the 3 most recently created answers should be shown
    Given "Steak Knife" has answered the following A La Minute questions:
    | question         | answer                  |  created_at     |
    | What's new?      | Lobster Bisque          |  3.hours.ago    |
    | What's changing? | Adding sidewalk seating |  2.hours.ago    |
    | What's up?       | Nothing much            |  30.minutes.ago |
    | Morning?         | Evening                 |  10.minutes.ago |

    And I go to the soapbox restaurant profile for "Steak Knife"
    Then I should see the question "What's changing?" with the answer "Adding sidewalk seating"
    And I should see the question "What's up?" with the answer "Nothing much"
    And I should see the question "Morning?" with the answer "Evening"
    And I should not see the answer "Lobster Bisque"

  Scenario: Answering a question
    Given the following a la minute questions:
     | question        |
     | What's new?     |
     | What's playing? |

    When I go to the edit a la minute question page for "Steak Knife"
    And I fill in a la minute question titled "What's new?" with answer "Salad"
    And I fill in a la minute question titled "What's playing?" with answer "Creed"
    And I press "Post"
    And I go to the restaurant show page for "Steak Knife"
    Then I should see the question "What's new?" with the answer "Salad"
    And I should see the question "What's playing?" with the answer "Creed"

  Scenario: Manager should see archived answers under each question
    Given "Steak Knife" has answered the following A La Minute questions:
      | question    | answer               | created_at     |
      | What's new? | Lobster Bisque       | 3.hours.ago    |
      | What's new? | Something newer      | 2.hours.ago    |
      | What's new? | Something even newer | 30.minutes.ago |

    When I go to the edit a la minute question page for "Steak Knife"
    Then I should see the question "What's new?" with the answer "Something even newer"
    And I should see the question "What's new?" with the answer "Something newer"
    And I should see the question "What's new?" with the answer "Lobster Bisque"

@javascript
  Scenario: Manager should be able to remove an answer
    Given "Steak Knife" has answered the following A La Minute questions:
      | question    | answer               | created_at     |
      | What's new? | Lobster Bisque       | 3.hours.ago    |
      | What's new? | Something newer      | 2.hours.ago    |
      | What's new? | Something even newer | 30.minutes.ago |
    And I go to the edit a la minute question page for "Steak Knife"
    When I follow "[remove]" for the answer "Something newer"
    Then I should see the question "What's new?" with the answer "Something even newer"
    And I should see the question "What's new?" with the answer "Lobster Bisque"
