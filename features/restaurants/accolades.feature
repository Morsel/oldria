Feature: Adding accolades to a restaurant
  In order to show off how awesome we are
  As a restaurant manager
  I want want to be able to add accolades to my restaurant

  Background:
    Given a restaurant named "Restaurant"

  Scenario: Add a new accolade for a restaurant
    Given I am logged in as an admin
    When I go to the edit restaurant page for "Restaurant"
    Then I see the ajax button for adding an accolade

  Scenario: Adding an award to your profile
    Given I am logged in as an admin
    When I go to the edit restaurant page for "Restaurant"
    When I add an accolade to the restaurant "Restaurant" with:
      | Name       | Best Restaurant              |
      | Run Date   | 2009-10-21                   |
      | Media Type | National television exposure |
    Then I should have 1 accolade on my restaurant profile
    And I should see an accolade for "Best Restaurant" on the profile page for "Restaurant"

  Scenario: Seeing the edit form
    Given I am logged in as an admin
    And an accolade for "Restaurant" named "Best Restaurant"
    When I go to the edit restaurant page for "Restaurant"
    And I click on the "Edit" link within "Best Restaurant"
    Then I should see the accolade form correctly



    