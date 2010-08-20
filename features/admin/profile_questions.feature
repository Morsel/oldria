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
    And fill in "Your question" with "How did you learn to cook?"
    And I select "Career building" from "Topic"
    And I select "Early on" from "Chapter"
    And I press "Save Question"
    Then I should see "Added new profile question"
    
  Scenario: creating a new chapter
    When I go to the chapters page
    And fill in "Title" with "Mentoring"
    And I press "Add"
    Then I should see "Created new chapter named Mentoring"
  
  Scenario: creating a new topic
    When I go to the new topic page
    And fill in "Title" with "Work Experience"
    And I press "Save Topic"
    Then I should see "Created new topic named Work Experience"
