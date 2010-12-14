@soapbox
Feature: Search question
  So that diners and journalists can find interesting content
  As a public user of the site
  I want to search for QOTD, TRENDS and answers to them by keyword.

  Scenario: Finding a QOTD
    Given there is a QOTD asking "Is alloy mug fancy?"
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-05-10 |
    And I go to the questions search page searching for "mug"
    Then I should see "Is alloy mug fancy?" within "#questions-list"

