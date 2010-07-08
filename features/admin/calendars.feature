@calendar @admin
Feature: admins can create and view calendar events
  Background:
  Given I am logged in as an admin

  Scenario: an admin views their calendar of events
  Given I go to the admin calendars page
  Then I should see a list of events
  
  Scenario: an admin creates a new event
  Given I go to the new admin event page
  And I select "Charity" from "Calendar"
  And I fill in "Title" with "Puppy Benefit"
  And I fill in "Location" with "the patio"
  When I press "Save"
  Then I should be on the admin calendars page
  And I should see "Puppy Benefit"
  