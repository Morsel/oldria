@profile
Feature: Profile questions
  As an admin,
  I want to create questions that restaurant managers can answer
  And organize these into chapters and topics

  Background:
    Given I am logged in as an admin
    And a restaurant role named "Chef"

  Scenario: creating a new topic for restaurants
    When I go to the new restaurant topic page
    And fill in "Title" with "Management"
    And I press "Save"
    Then I should see "Created new topic named Management"

  Scenario: viewing all profile questions for restaurant
    Given the following restaurant chapters:
      | title    | topic   |
      | Early on | History |
    And I have created the following restaurant profile questions:
      | chapter  | question                                                |
      | Early on | What restaurant's were you inspired by when you opened? |
      | Early on | What year did you open for business?                    |
    When I go to the admin restaurant profile questions page
    Then I should see "Add new question"
    And I should see "Manage topics"
    And I should see "Manage chapters"
    And I should see "Early on"
    And I should see "History"
    And I should see "What restaurant's were you inspired by when you opened?"
    And I should see "What year did you open for business?"

  Scenario: creating a restaurant topic
    When I go to the new restaurant topic page
    And fill in "Title" with "At the Moment"
    And I press "Save"
    Then I should see "Created new topic named At the Moment"

  Scenario: viewing restaurant topics
    Given I have created the following restaurant topics:
     | topic         |
     | At the Moment |
     | Early on      |
    When I go to the restaurant topics page
    Then I should see "At the Moment"
    And I should see "Early on"

  Scenario: creating a restaurant chapter
    Given the following restaurant topics:
      | topic   |
      | History |
    When I go to the restaurant chapters page
    And I fill in "Title" with "First Employee"
    And I press "Save"
    Then I should see "Created new chapter named First Employee"

  Scenario: viewing chapters
    Given the following restaurant chapters:
      | title    | topic           |
      | Early on | Career building |
    When I go to the restaurant chapters page
    Then I should see "Early on"
    And I should see "Career building"

  # Scenario: creating a new chapter
  #   When I go to the chapters page
  #   And fill in "Title" with "Mentoring"
  #   And I press "Save"
  #   Then I should see "Created new chapter named Mentoring"
  #
  # Scenario: creating a new topic
  #   When I go to the new topic page
  #   And fill in "Title" with "Work Experience"
  #   And I press "Save Topic"
  #   Then I should see "Created new topic named Work Experience"



