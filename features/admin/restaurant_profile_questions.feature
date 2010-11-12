@profile
Feature: Profile questions
  As an admin,
  I want to create questions that restaurant managers can answer
  And organize these into chapters and topics

  Background:
    Given I am logged in as an admin
    And the following restaurant chapters:
      | title    | topic   |
      | Early on | History |
    And a restaurant role named "Chef"

  Scenario: creating a new top for restaurants
    When I go to the new restaurant topics page
    And fill in "Title" with "Management"
    And I press "Save"
    Then I should see "Created new topic named Management"

# @wip
  Scenario: viewing all profile questions for restaurant
    Given I have created the following restaurant profile questions:
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

  Scenario: new restaurant topics
    Given I go to the new restaurant topic page
    And fill in "Title" with "At the Moment"
    And I press "Save"
    Then I should see "Created new topic named At the Moment"

@wip
  Scenario: title
    Given I have created the following restaurant topics:
     | topic         |
     | At the Moment |
     | Early on      |
    When I go to the restaurant topic page
    Then I should see "At the Moment"
    And I should see "Early on"

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



