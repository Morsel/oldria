Feature: Manage a_la_minutes
  In order to provide current information for our users
  Our restaurant managers and employees
  wants to be able to answer a la minute questions

  Background:
    Given the following a la minute questions:
      | question                                      |
      | What's the newest item on your menu?          |
      | What music is playing in your kitchen?        |
    Given a restaurant named "Steak Knife"
    And I am logged in as an admin

  Scenario: Questions are displayed for a manager
    When I go to the restaurant show page for "Steak Knife"
    Then I see a header for a la minute
    And I see the text for each question

  Scenario: Answers for each question are displayed
    And "Steak Knife" has answered the following A La Minute questions:
     | question        | answer         |
     | What's new?     | Lobster Bisque |

    When I go to the restaurant show page for "Steak Knife"
    Then I should see the answer "Lobster Bisque"

  Scenario: Answers can be shared publicly
    Given "Steak Knife" has answered the following A La Minute questions:
     | question        | answer         |
     | What's new?     | Lobster Bisque |

    When I go to the restaurant show page for "Steak Knife"
    And I check "a_la_minute_answer_1"
    And I press "Save"
    And I go to the soapbox restaurant profile for "Steak Knife"
    Then I should see the question "What's new?" with the answer "Lobster Bisque"
