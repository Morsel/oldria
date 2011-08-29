@profile
Feature: Profile Accolades
  Users many choose none, one or many of: 
    Run Date, Type ( national television exposure, local TV exposure, 
    national press, significant local press), Name, Link

  Scenario: Adding an award to your profile
    Given I am logged in as a normal user with a profile
    And I am on my profile's edit page
    And I follow "Résumé"
    When I add an accolade to my profile with:
      | Name       | Top Chef                     |
      | Run Date   | 2009-10-21                   |
      | Media Type | National television exposure |
    Then I should have 1 accolade on my profile
    And I should see "Top Chef" on my profile page
