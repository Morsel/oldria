@profile @btl
Feature: Profile - Behind the Line (aka Q&A)
  SF users should be able to answer questions specific to their employment roles
  These questions will be organized into a series of topics and chapters

  Background:
  Given the following confirmed users:
    | username    | password | first_name | last_name |
    | punkrock    | secret   | John       | Smith     |
  And several profile questions matching employment roles for "punkrock"
  And I am logged in as "punkrock"

  Given "punkrock" has a complimentary premium account
  And "punkrock" has a published profile

  Scenario: Viewing my topics
    Given I am on the profile page for "punkrock"
    When I follow "learn more about John" within "#behind"
    Then I should see "Topics"

  Scenario: Viewing chapters for a topic
    Given I am on the profile page for "punkrock"
    When I follow "learn more about John" within "#behind"
    And I follow "View all"
    Then I should see "John Smith Behind the Line" within "title"

  Scenario: Viewing questions in a chapter
    Given I am on the profile page for "punkrock"
    When I follow "learn more about John" within "#behind"
    And I follow "View all"
    And I follow "Education"
    And I should see "Education - John Smith - Behind The Line" within "title"

  Scenario: Answering a question
    Given I am on the profile page for "punkrock"
    When I follow "learn more about John" within "#behind"
    And I follow "View all"
    And I follow "Education"
    And I fill in question titled "Title 1" with answer "A great answer for this"
    And I press "Post"
    Then I should see "Your answers have been saved"
    And I should see "A great answer for this"

  Scenario: User answers a Behind The Line question and post to facebook
    Given "punkrock" has a complimentary premium account
    And Facebook is functioning
    And given that user "punkrock" has facebook connection
    And I am on the profile page for "punkrock"
    When I follow "learn more about John" within "#behind"
    And I follow "View all"
    And I follow "Education"
    And I fill in question titled "Title 1" with answer "A great answer for this"
    And I should see "Post to Facebook"
    And I check "Post to Facebook?"
    And I press "Post"
    Then message to facebook is sent
