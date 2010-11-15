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
    And a restaurant role named "Chef"

  Scenario: creating a new profile question
    When I go to the new user profile question page
    And fill in "Your question" with "How did you learn to cook?"
    And I select "Career building" from "Topic"
    And I select "Early on" from "Chapter"
    And I check "Chef"
    And I press "Save Question"
    Then I should see "Added new profile question"

  Scenario: creating a new chapter
    When I go to the user chapters page
    And fill in "Title" with "Mentoring"
    And I press "Save"
    Then I should see "Created new chapter named Mentoring"

  Scenario: creating a new topic
    When I go to the new user topic page
    And fill in "Title" with "Work Experience"
    And I press "Save Topic"
    Then I should see "Created new topic named Work Experience"
