@soapbox @otm
Feature: Soapbox - On the Menu
  As a public user of the site, I want to see recent menu items from restaurants.

  Background:
    Given a restaurant named "River Deli"
    And the following menu items for "River Deli":
      | name       | price |
      | butterkase | 3.00  |

  Scenario: Viewing all recent menu items
    When I go to the soapbox menu items page
    Then I should see "On the Menu"
    And I should see "butterkase"
    And I should see "River Deli"
