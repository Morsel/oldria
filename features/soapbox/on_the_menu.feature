@soapbox @otm
Feature: Soapbox - On the Menu
  As a public user of the site, I want to see recent menu items from restaurants.

  Background:
    Given a premium restaurant named "River Deli"
    And the following menu items for "River Deli":
      | name       | price |
      | Butterkase | 3.00  |

  Scenario: Viewing all recent menu items
    When I go to the soapbox menu items page
    Then I should see "On the Menu"
    And I should see "Butterkase"
    And I should see "River Deli"

  Scenario: Viewing details and share links for a menu item
    When I go to the soapbox menu items page
    And I follow "Butterkase"
    Then I should see "On the Menu"
    And I should see "Butterkase"
    And I should see "River Deli"
