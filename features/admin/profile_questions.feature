@profile
Feature: Profile questions
  As an admin,
  I want to create questions that users can answer
  And organize these into chapters and topics
  
  Background:
    Given I am logged in as an admin
    And the following chapters:
      | title    | topic           |
      | Early on | Career building |
  
  Scenario: creating a new profile question
    When I go to the new profile question page
    And fill in "title" with "How did you learn to cook?"
    And I select "Career building - Early on" from "Chapter"
    And I press "Save Question"
    Then I should see "Added new profile question"
    
  Scenario: managing the questions in a chapter group
    Given the following questions:
      | title                         | chapter  |
      | How did you learn to cook?    | Early on |
      | What is your formal training? | Early on |
    When I go to the admin profile questions page
    And I follow "Manage"
    Then I should see "How did you learn to cook?"
    And I should see "What is your formal training?"