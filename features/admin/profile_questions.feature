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
    And enter the question title "How did you learn to cook?"
    And I select "Career building - Early on" from "Chapter"
    And I press "Submit"
    Then I should see "Added new profile question"