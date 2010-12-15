@sharing
Feature: AddThis sharing feature
  Background:
  Given the following confirmed users:
    | username    | password | first_name | last_name |
    | john        | secret   | John       | Smith     |
  And several profile questions matching employment roles for "john"
  And the user "john" has a premium account
  And I am logged in as "john"

  Scenario: User with premium account can share profile
    And I am on the profile page for "john"
    Then I should see addThis button

  Scenario: Question page should AddThis UI feature
    Given I am on the question page with title "Title 1"
    Then I should see addThis button

  Scenario: Topic should contain button addThis
    Given I am on the profile page for "john"
    And profile question matching employment role with static topic name for "john"
    When I follow "View all Topics" within "#behindline"
    When I follow "SeoTopic"
    Then I should see addThis button

  Scenario: Chapter questions page should contain AddThis UI feature
    Given I am on the profile page for "john"
    When I follow "View all Topics" within "#behindline"
    And I follow "View all"
    And I follow "Education"
    Then I should see addThis button
          
  Scenario: Viewing addThis on user profiles
    Given the following published users:
      | username    | password |
      | punkrock    | secret   |
    And "punkrock" has a default employment with role "Executive Chef" and restaurant name "Aquavit"
    And "punkrock" has a complimentary premium account
    And I go to the soapbox profile page for "punkrock"
    Then I should see addThis button

  Scenario: Viewing the addThis button on front_burner page
    Given there is a QOTD asking "Where do you buy flowers?"
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-05-10 |
    And there is a Trend Question "What is the haps?: Boo-ya"
    When I create a new soapbox entry for that Trend Question with:
      | Published at | 2010-05-10 |

    When I go to the soapbox front burner page
    Then I should see "Where do you buy flowers?"
    And I should see "What is the haps?: Boo-ya"
    And I should see two addThis buttons
