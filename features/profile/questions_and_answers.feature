@profile
Feature: Profile - Behind the Line (aka Q&A)
  SF users should be able to answer questions specific to their employment roles
  These questions will be organized into a series of topics and chapters
  
  Background:
  Given the following confirmed users:
    | username    | password | first_name | last_name |
    | punkrock    | secret   | John       | Smith     |
  And several profile questions matching employment roles for "punkrock"
  And I am logged in as "punkrock"
  
  Scenario: Viewing my topics
    Given I am on the profile page for "punkrock"
    When I follow "View all Topics" within "#behindline"
    Then I should see "Topics"
    
  Scenario: Viewing chapters for a topic
    Given I am on the profile page for "punkrock"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    Then I should see "Education"

  Scenario: Viewing questions in a chapter
    Given I am on the profile page for "punkrock"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    Then I should see "Title 1"
    
  Scenario: Answering a question
    Given I am on the profile page for "punkrock"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    And I fill in "profile_question_1_answer" with "A great answer for this"
    And I press "Post"
    Then I should see "Your answers have been saved"

  Scenario: Should contain topic name and chief name in title
    Given I am on the profile page for "punkrock"
    And profile question matching employment role with static topic name for "punkrock"
    When I follow "View all Topics" within "#behindline"
    When I follow "SeoTopic"
    And I should see "SeoTopic - John Smith" within "title"
    
  Scenario: Topic should contain button addThis
    Given I am on the profile page for "punkrock"
    And profile question matching employment role with static topic name for "punkrock"
    When I follow "View all Topics" within "#behindline"
    When I follow "SeoTopic"
    Then I should see addThis button

  Scenario: Question page should contain question name in title
    Given I am on the question page with title "Title 1"
    And I should see "Title 1 - Behind The Line" within "title"

  Scenario: Chapter questions page should contain chapter title and chief name in title
    Given I am on the profile page for "punkrock"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    Then I should see "Education - John Smith - Behind The Line" within "title"

  Scenario: Chapter questions page should contain AddThis UI feature
    Given I am on the profile page for "punkrock"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    Then I should see addThis button
          
  Scenario: Question page should AddThis UI feature
    Given I am on the question page with title "Title 1"
    Then I should see addThis button

  Scenario: User answers a Behind The Line question and post to facebook
    Given "punkrock" has a complimentary premium account
    And Facebook is functioning
    And given that user "punkrock" has facebook connection
    And I am on the profile page for "punkrock"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    And I fill in "profile_question_1_answer" with "A great answer for this"
    And I should see "Post to Facebook"
    And I check "Post to Facebook?"
    And I press "Post"
    Then message to facebook is sent 


