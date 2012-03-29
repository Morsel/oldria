@profile
Feature: Profile - Awards
  SF users should be able to share their awards on their profiles,
  with information like the following:

  Name of Award*
  Year Won*
  Year Nominated*


  Scenario: Adding an award to your profile
    Given I am logged in as a normal user with a profile
    And I am on my profile's edit page
    When I add an award to my profile with:
      | Name of Award  | Top Chef |
      | Year won       | 2009     |
      | Year nominated | 2008     |
    Then I should have 1 award on my profile
    And I should see "Top Chef (2009)" on my profile page
