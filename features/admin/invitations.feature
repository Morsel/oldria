@invitations
Feature: RIA admins can review invitations, approve and archive them

  Background:
  Given I am logged in as an admin
  And there are the following invitations:
    | first_name  | last_name | email                | restaurant_name |
    | Mariah      | Carpenter | mc@restaurants.com   | Fin             |
    | Andrew      | Ruth      | ruth@anothercook.com | Feather         |
  
  Scenario: viewing invitation requests
  Given I go to the admin invitations page
  Then I should see "MariahCarpenter"
  
  Scenario: editing invitations
  Given I go to the admin invitations page
  And I follow "edit"
  And I fill in "invitation_restaurant_name" with "Flank"
  And I press "Save"
  Then I should see "Flank"
  
  Scenario: approving an invitation
  Given I go to the admin invitations page
  And I follow "accept"
  Then "mariahcarpenter" should be a confirmed user
  # one email for the you've been invited message, one for the approval
  And "mc@restaurants.com" should have 2 emails
