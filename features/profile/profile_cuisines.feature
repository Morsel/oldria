@profile
Feature: Profile Cuisines
  Users may select one or more cuisines to appear on their profile
  
  Background:
  Given a cuisine named "Fondue"

  Scenario: Adding a cuisine to your profile
    Given I am logged in as a normal user with a profile
    And I am on my profile's edit page
    And I follow "Résumé" within "#profile-tabs"
    When I add a cuisine to my profile with:
      | Cuisine   | Fondue    |
    Then I should have 1 cuisine on my profile
    When I am on my profile page
    Then I should see "Fondue"
  