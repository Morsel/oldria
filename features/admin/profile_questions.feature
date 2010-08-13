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
    And I select "[Cuisine] Career building - Early on" from "Chapters"
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
    
  Scenario: creating a new chapter
    When I go to the new profile question page
    And fill in "Chapter Title" with "Mentoring"
    And I select "[Cuisine] Career building" from "Topic"
    And I press "Save Chapter"
    Then I should see "Created new chapter named Mentoring"
  
  Scenario: creating a new topic
    When I go to the new profile question page
    And fill in "Topic Title" with "Work Experience"
    And I check "Cuisine"
    And I press "Save Topic"
    Then I should see "Created new topic named Work Experience"
    
  Scenario: managing roles
    Given a restaurant role named "Chef Assistant"
    And a restaurant role named "Chef de Cuisine"
    When I go to the admin profile questions page
    And I follow "Manage roles"
    And I fill in "Name" with "Culinary"
    Then I should see "Chef Assistant"
    And I check "Chef de Cuisine"
    And I press "Save"
    Then I should see "Created role"
    And I should see "Culinary"
