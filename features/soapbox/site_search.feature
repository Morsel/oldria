@soapbox @search
Feature: Search question
  So that diners and journalists can find interesting content
  As a public user of the site
  I want to search for QOTD, TRENDS and answers, BTL and user profiles by keyword.

  Background:
    Given There is a searchable user with a communicative profile
    And a premium restaurant named "Whisky House"
    And several profile questions matching employment roles for "searchable"

  Scenario: Finding a QOTD
    Given there is a QOTD asking "Is alloy mug fancy?"
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-05-10 |
    And I go to the soapbox search page searching for "mug"
    Then I should see "Is alloy mug fancy?" within ".search-results"

  Scenario: Finding a Trend Question
    Given there is a Trend Question "How much water do you pour into milk?: Please don't do this at home"
    And that Trend Question is featured on the soapbox
    When I go to the soapbox search page searching for "water"
    Then I should see "water" within ".search-results"

  Scenario: Finding a QOTD comment
    Given there is a QOTD asking "Is alloy mug fancy?"
    And that QOTD has the following answers:
      | Alec Lable | Please, drink from a plastic one |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-05-10 |
    And I go to the soapbox search page searching for "plastic"
    Then I should see "Please, drink from a plastic one" within ".search-results"

  Scenario: Finding user profile
    When I go to the soapbox search page searching for "ketchup"
    Then I should see "Bob Ichvinstone" within ".search-results"

  Scenario: Finding restaurant profile
    When I go to the soapbox search page searching for "whisky house"
    Then I should see "Whisky House" within ".search-results"

  Scenario: Finding BTL quesiton
    Given I am logged in as "searchable" with password "searchable"
    And I am on the profile page for "searchable"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    And I fill in question titled "Title 1" with answer "A dumb answer"
    And I press "Post"
    When I go to the soapbox search page searching for "Title 1"
    Then I should see "Title 1" within ".search-results"

  Scenario: Finding BTL answer
    Given I am logged in as "searchable" with password "searchable"
    And I am on the profile page for "searchable"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    And I fill in question titled "Title 1" with answer "A great answer for this"
    And I press "Post"
    When I go to the soapbox search page searching for "great answer"
    Then I should see "A great answer for this" within ".search-results"
