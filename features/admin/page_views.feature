@admin @page_views
Feature: Page view tracking
  So that RIA admins can monitor media users' actions for PR customers
  The site should log when media users view a restaurant or user content page

  Background:
	Given a restaurant named "August Fields"

@javascript
  Scenario: An admin can see a list of recent page views
	Given I am logged in as a media member
	And I go to the restaurant show page for "August Fields"
	And I follow "John Doe"
	And I wait for all AJAX to finish
	Then there should be 2 page views in the system

    Given I am logged in as an admin
	And I go to the admin page views page
	Then I should see "Page Views"
	And I should see "viewed August Fields"
