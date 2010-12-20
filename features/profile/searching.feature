@profile
Feature: Profile - Search profiles and Behind the Line (aka Q&A)
  Soapbox users should be able to find user profiles and BTL Q&A with keyword search

  Background:
  Given There is a searchable user with a communicative profile
  And several profile questions matching employment roles for "searchable"

  Scenario: Finding user profile
    When I go to the users search page searching for "ketchup"
    Then I should see "Bob Ichvinstone" within "#user-results"

  Scenario: Finding BTL quesiton
    Given I am logged in as "searchable" with password "searchable"
    And I am on the profile page for "searchable"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    And I fill in "profile_question_1_answer" with "A great answer for this"
    And I press "Post"
    When I go to the behind the line questions search page searching for "Title 1"
    Then I should see "Title 1" within "#recently"

  Scenario: Finding BTL answer
    Given I am logged in as "searchable" with password "searchable"
    And I am on the profile page for "searchable"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    And I fill in "profile_question_1_answer" with "A great answer for this"
    And I press "Post"
    When I go to the behind the line questions search page searching for "great answer"
    Then I should see "A great answer for this" within "#recently"

