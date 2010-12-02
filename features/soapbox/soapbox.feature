@soapbox
Feature: Soapbox
  So that the public, diners, and media can get the inside story from chefs directly
  As a public user of the site
  I want to see QOTD and TRENDS as a public stream.


  Scenario: Featuring a QOTD on the soapbox
    Given there is a QOTD asking "Where do you buy flowers"
    And that QOTD has the following answers:
      | John Doeface  | I like to get them at the store |
      | Patty Wallace | Hand-picked, all the way!       |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-05-10 |
    Then there should be 1 QOTD on the soapbox front burner page

  Scenario: Featuring links to other questions on the question page within the soapbox front burner
    Given there is a QOTD asking "Where do you buy flowers"
    And that QOTD is featured on the soapbox
    And there is a Trend Question "What is the haps?: Boo-ya"
    And that Trend Question is featured on the soapbox
    When I selected corresponding soapbox entry
    Then I should see "Trend Questions" within "aside"
    And I should see "Questions of the Day" within "aside"
    And I should see "All Questions" within "aside"

  Scenario: Viewing the addThis button
    Given the following published users:
    | username    | password |
    | punkrock    | secret   |
    And I am on the profile page for "punkrock"
    Then I should see addThis button

  Scenario: Viewing a QOTD soapbox entry title
    Given there is a QOTD asking "Where do you buy flowers"
    And that QOTD is featured on the soapbox
    When I selected corresponding soapbox entry
    Then I should see "Where do you buy flowers - Soapbox Question of the Day" within "title"

  Scenario: Viewing a Trend Question soapbox entry title
    Given there is a Trend Question "What is the haps?: Boo-ya"
    And that Trend Question is featured on the soapbox
    When I selected corresponding soapbox entry
    Then I should see "What is the haps?: Boo-ya - Soapbox Trend" within "title"





