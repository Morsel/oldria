@invitations
Feature: RIA admins can review invitations, approve and archive them

  Background:
  Given I am logged in as an admin
  And there are the following invitations:
    | first_name  | last_name | email                |
    | Mariah      | Carpenter | mc@restaurants.com   |
    | Andrew      | Ruth      | ruth@anothercook.com |
  
  Scenario: viewing invitation requests
  Given I go to the admin invitations page
  Then I should see "MariahCarpenter"
  
  Scenario: editing invitations
  Given I go to the admin invitations page
  And I follow "edit"
  And I fill in "Job title" with "Line Cook"
  And I press "Save"
  Then I should see "Line Cook"
  
  Scenario: approving an invitation
  Given I go to the admin invitations page
  And I follow "accept"
  Then "mariahcarpenter" should be a confirmed user
  And "mc@restaurants.com" should have 1 email
