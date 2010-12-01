@profile
Feature: Restaurant Profile - Behind the Line (aka Q&A)
  SF restaurant managers should be able to answer questions specific to their restaurant
  These questions will be organized into a series of topics and chapters

  Background:
  Given the following confirmed users:
    | username    | password |
    | punkrock    | secret   |
  And a restaurant named "The Chef" with manager "Bob"
  And the following restaurant profile questions:
    | topic      | chapter       | question                               | page    |
    | Early on   | Inspirations  | What restaurants inspired you to open? | About   |
    | Early on   | Funding       | How did you make ends meet?            | Other   |
  And I am logged in as "Bob"

  Scenario: Viewing my topics
    Given I am on the restaurant show page for "The Chef"
    When I follow "View all Topics" within "#behindline"
    Then I should see "Topics"

  Scenario: Viewing chapters for a topic
    Given I am on the restaurant show page for "The Chef"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    Then I should see "Inspirations"
    And I should see "Funding"

  Scenario: Viewing questions in a chapter
    Given I am on the restaurant show page for "The Chef"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Inspirations"
    Then I should see "What restaurants inspired you to open?"

@wip
  Scenario: Answering a question
    Given I am on the restaurant show page for "The Chef"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Inspirations"
    And I fill in "profile_answer_answer" with "A great answer for this"
    And I press "Post"
    Then I should see "Your answer has been saved"
