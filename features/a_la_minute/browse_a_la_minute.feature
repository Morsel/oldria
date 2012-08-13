@alm
Feature: Browse a la minute
  In order to discover new restaurants and users
  As a site user
  I want to see a list of a la minute questions and answers to a la minute questions

  Background: title
    Given a restaurant named "Steak Knife"
    And that "Steak Knife" has a premium account
    And I am logged in as a normal user

  Scenario: Browse answers to questions on profile pages
    Given "Steak Knife" has answered the following A La Minute questions:
     | question    | answer       | public |
     | What's new? | Steak Knives | true   |

    When I go to the soapbox restaurant profile for "Steak Knife"
    And I follow "What's new?"
    Then I should see the heading "A la Minute"
    And I should see "What's new?"
    And I should see the answer "Steak Knives" for "Steak Knife"
