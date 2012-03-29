@restaurant_profile
Feature: Adding accolades to a restaurant
  In order to show off how awesome we are
  As a restaurant manager
  I want want to be able to add accolades to my restaurant

  Background:
    Given a restaurant named "Restaurant"
    And that "Restaurant" has a premium account
    Given I am logged in as an admin

  Scenario: Add a new accolade for a restaurant
    When I go to the edit restaurant page for "Restaurant"
    Then I see the ajax button for adding an accolade

  Scenario: Adding an award to your profile
    When I go to the edit restaurant page for "Restaurant"
    When I add an accolade to the restaurant "Restaurant" with:
      | Name       | Best Restaurant              |
      | Run date   | 2009-10-21                   |
      | Media type | National television exposure |
    Then I should have 1 accolade on my restaurant profile
    And I should see an accolade for "Best Restaurant" on the profile page for "Restaurant"

  Scenario: Seeing the edit form
    And an accolade for "Restaurant" named "Best Restaurant"
    When I go to the edit restaurant page for "Restaurant"
    And I click on the "Edit" link within "Best Restaurant"
    Then I should see the accolade form correctly

    Scenario: Accolades display
    Given an accolade for "Restaurant" named "Best Restaurant"
    When I go to the soapbox restaurant profile for "Restaurant"
    Then I should see an accolades section

    Scenario: Accolade link non-display
    When I go to the soapbox restaurant profile for "Restaurant"
    Then I should not see an accolades section

    Scenario: Accolade interior page display
    Given an accolade for "Restaurant" named "Best Restaurant" dated "September 2, 2009"
    Given an accolade for "Restaurant" named "Extra Yummy" dated "September 10, 2010"
    When I go to the soapbox restaurant profile for "Restaurant"
    Then I should see the accolades in order: "Extra Yummy, Best Restaurant"
