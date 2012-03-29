@alm
Feature: A La Minute Question/Answer Management
  In order to give customers better insight into the heart and soul of a restaurant
  As an admin
  I want to be able to create, view, edit, and destroy A La Minute Questions so that restaurant Managers/Users can answer them

  Background:
    Given I am logged in as an admin

  Scenario: View a list of all A La Minute Questions
    Given I have created the following A La Minute Questions:
     | question         | kind       |
     | What's new?      | restaurant |
     | What's changing? | restaurant |
     | Who's your idol? | user       |

    When I go to the admin a la minute questions page
    Then I should see the following questions:
     | question         |
     | What's new?      |
     | What's changing? |

@javascript
  Scenario: Delete a question
    Given I have created the following A La Minute Questions:
     | question         | kind       |
     | What's new?      | restaurant |
     | What's changing? | restaurant |

    When I go to the admin a la minute questions page
    And I follow "Destroy"
    Then I should see the following questions:
     | question         |
     | What's changing? |

  Scenario: Create a new question
    When I go to the admin a la minute questions page
    And I fill in "a_la_minute_question_question" with "What's new?"
    And I press "Add"
    Then I should see the following questions:
     | question    |
     | What's new? |
