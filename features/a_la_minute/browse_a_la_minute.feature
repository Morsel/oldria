@alm
Feature: Browse a la minute
  In order to discover new restaurants and users
  As a site user
  I want to see a list of a la minute questions and answers to a la minute questions

  Background: title
    Given a restaurant named "Steak Knife"
    And that "Steak Knife" has a premium account
    Given a restaurant named "Piece"
    And that "Piece" has a premium account
    And a restaurant named "Bourgeois Pig"
    And that "Bourgeois Pig" has a premium account
    And I am logged in as a normal user
    And the user "normal" is an account manager for "Piece"

  Scenario: Browse other answers to questions on profile pages
    Given "Steak Knife" has answered the following A La Minute questions:
     | question    | answer       | public |
     | What's new? | Steak Knives | true   |

    And "Piece" has answered the following A La Minute questions:
     | question    | answer         | public |
     | What's new? | Lobster Bisque | true   |

    And "Bourgeois Pig" has answered the following A La Minute questions:
     | question    | answer     | public |
     | What's new? | Pork Chops | true   |

    When I go to the soapbox restaurant profile for "Steak Knife"
    And I follow "What's new?"
    Then I should see the heading "What's new?"
    And I should see the answer "Steak Knives" for "Steak Knife"
    And I should see the answer "Lobster Bisque" for "Piece"
    And I should see the answer "Pork Chops" for "Bourgeois Pig"
