@soapbox
Feature: Soapbox
  So that the public, diners, and media can get the inside story from chefs directly
  As a public user of the site
  I want to see QOTD and TRENDS as a public stream.

  Background:
    Given links are shortened with bit.ly

  Scenario: Featuring a QOTD on the soapbox
    Given there is a QOTD asking "Where do you buy flowers?"
    And that QOTD has the following answers:
      | John Doeface  | I like to get them at the store |
      | Patty Wallace | Hand-picked, all the way!       |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at  | 2010-05-10 |
	  | Daily feature | true       |
    Then there should be 1 QOTD on the soapbox front burner page

  Scenario: Viewing a QOTD soapbox entry title
    Given there is a QOTD asking "Where do you buy flowers?"
    And that QOTD has the following answers:
      | John Doeface  | I like to get them at the store |
      | Patty Wallace | Hand-picked, all the way!       |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at  | 2010-05-10 |
	  | Daily feature | true       |
    Then there should be 1 QOTD on the soapbox front burner page

  Scenario: Featuring links to other questions on the question page within the soapbox front burner
    Given there is a QOTD asking "Where do you buy flowers"
    And that QOTD is featured on the soapbox
    And there is a Trend Question "What is the haps?: Boo-ya"
    And that Trend Question is featured on the soapbox
    When I follow the corresponding soapbox entry link
    Then I should see "What's New" within "aside"
    And I should see "Questions of the Day" within "aside"
    And I should see "View all" within "aside"

  Scenario: Featuring all QOTDs on a separate page
    Given there is a QOTD asking "How do you boil ketchup: For scientific purposes only, I promise"
    And that QOTD has the following answers:
      | Archibald Goodwill | I like to get them at the store |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-12-06 |
    Given there is a QOTD asking "How do you freeze ketchup"
    And that QOTD has the following answers:
      | Andrew Gotzky | I like to move it |
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-12-06 |
    And I go to the all of the qotd questions listing page
    Then I should see "Questions of the Day" within "#questions-list"
    And I should see "How do you boil ketchup" within "#questions-list-feed-qotd"
    And I should see "How do you freeze ketchup" within "#questions-list-feed-qotd"

  Scenario: Featuring all Trends on a separate page
    Given there is a Trend Question "The best ketchup in the world: Where can I find it?"
    And that Trend Question is featured on the soapbox
    Given there is a Trend Question "Hot water supplier: Is that even a thing?"
    And that Trend Question is featured on the soapbox
    When I go to the all of the trend questions listing page
    Then I should see "Previous Features" within "#questions-list"
    And I should see "The best ketchup in the world" within "#questions-list-feed-trend"
    And I should see "Hot water supplier" within "#questions-list-feed-trend"

  Scenario: Viewing a QOTD soapbox entry title
    Given there is a QOTD asking "Where do you buy flowers?"
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at  | 2010-12-06 |
	  | Daily feature | true       |
    And I go to the soapbox front burner page
    And I follow "Where do you buy flowers?"
    Then I should see "Where do you buy flowers? - Soapbox Question of the Day" within "title"

  Scenario: Viewing a Trend Question soapbox entry title
    Given there is a Trend Question "What is the haps?: Boo-ya"
    And I am logged in as an admin
    When I create a new soapbox entry for that Trend Question with:
      | Published at  | 2010-05-10 |
	  | Daily feature | true       |
    When I go to the soapbox front burner page
    And I follow "What is the haps?: Boo-ya"
    Then I should see "What is the haps?: Boo-ya - Soapbox Trend" within "title"

