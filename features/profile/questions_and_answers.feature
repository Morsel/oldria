@profile
Feature: Profile - Behind the Line (aka Q&A)
  SF users should be able to answer questions specific to their employment roles
  These questions will be organized into a series of topics and chapters
  
  Background:
  Given the following confirmed users:
    | username    | password |
    | punkrock    | secret   |
  And several profile questions matching employment roles for "punkrock"
  And I am logged in as "punkrock"
  
  Scenario: Viewing my topics
    Given I am on the profile page for "punkrock"
    When I follow "Edit" within "#behindline"
    Then I should see "Topics"
    
  Scenario: Viewing chapters for a topic
    Given I am on the profile page for "punkrock"
    And I follow "Edit" within "#behindline"
    And I follow "View all"
    Then I should see "Education"

  Scenario: Viewing questions in a chapter
    Given I am on the profile page for "punkrock"
    And I follow "Edit" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    Then I should see "Title 1"
