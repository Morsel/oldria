Feature: Member search
  So that I can increase my social networking
  As a SpoonFeed member
  I want to search for other SpoonFeed members based on criteria such as position, market area, restaurant name


  Background:
    Given I am logged in as a normal user
    And the following user records:
    | username  | email              | name           |
    | jonny5    | jonny5@example.com | John Appleseed |
    | sarahbear | sarahbear@msn.com  | Sarah Cooper   |

  Scenario: Normal search
    Given I am on the homepage
    When I follow "Search for People"
    And I fill in "Username or Name" with "John"
    And I press "Search"
    Then I should see 1 search result
    And I should see "John Appleseed"
    And I should not see "Sarah Cooper"


  Scenario: No results
    Given I am on the homepage
    When I follow "Search for People"
    And I fill in "Username or Name" with "Mary"
    And I press "Search"
    Then I should see no search results
    And I should not see "John Appleseed"


  