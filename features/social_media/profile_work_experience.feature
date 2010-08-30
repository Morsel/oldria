@profile
Feature: Profile - Work Experience
  SF users should be able to share their restaurants (previous and current)
  on their profiles, with information like the following:

  Restaurant Name, Title, City, State, Country, Work dates (range),
  Chef In Charge of menu, Type of Cuisine Served, Anything Notable


  Scenario: Adding restaurant work experience
    Given I am logged in as a normal user
    And I am on my profile's edit page
    When I add a restaurant to my profile with:
      | Restaurant name        | Jose's                   |
      | Title                  | Head Chef                |
      | City                   | Atlanta                  |
      | State                  | GA                       |
      | Country                | United States            |
      | Dates                  | 2009-10-01 to 2009-12-02 |
      | Chef in charge of menu | John Denver              |
      | Type of cuisine served | American (Classic)       |
    Then I should have 1 restaurant on my profile
    And I should see "Jose's" on my profile page


  Scenario: Add a non-restaurant to work experience
    Given I am logged in as a normal user
    And I am on my profile's edit page
    When I add a nonculinary job to my profile with:
      | Company                              | Exxon Mobile             |
      | Title                                | CEO                      |
      | City                                 | Indianapolis             |
      | State                                | IN                       |
      | Country                              | United States            |
      | Dates                                | 2009-10-01 to 2009-12-02 |
      | Responsibilities and Accomplishments | Bossing people around    |
      | Reason for leaving                   | I loved food too much    |
    Then I should have 1 nonculinary job on my profile
    And I should see "Exxon Mobile" on my profile page

