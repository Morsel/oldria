@admin
Feature: Site-wide activity feed
  So that RIA admins can monitor what users are doing
  The site should track certain kinds of changes and display them in an activity feed view

  Background:
	Given a restaurant named "August Fields"
	And a manager for "August Fields" has just uploaded a new menu

  Scenario: An admin can see a list of recent activity
    Given I am logged in as an admin
	And I go to the site activities page
	Then I should see "Site Activity Updates"
	And I should see "Saved menu"
