@payment
Feature: Restaurant Accounts
  So that a restaurant can add it's users as premium accounts
  
  Background:
    Given a restaurant named "Taco Bell" with the following employees:
      | username | password | email            | name      | role      |
      | emily    | secret   | emily@example.com| Emily     | Manager   |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      |
      | john     | secret   | john@example.com | John Doe  | Sommelier |
    Given "emily" is a manager for "Taco Bell"
    Given "emily" is the account manager for "Taco Bell"
    Given I am logged in as "emily" with password "secret"
  
  @wip
	Scenario: A premium restaurant adds a user without a premium account
		When I go to the employees page for "Taco Bell"
		When I follow the edit role link for "Sam Smith"
		Then I see that "sam" has a basic account
		When I follow "Upgrade employee account to premium"
		Then I should be on the employee edit page for "Taco Bell" and "sam"
		And I see that "sam" has a premium account
	
	Scenario: A complimentary restaurant adds a user without a premium account
	
	Scenario: A complimentary restaurant adds a second user without a premium account
	
	Scenario: A premium restaurant adds a user that already has a premium account
		# user's subscription gets cancelled
		# add on 
	
	Scenario: A restaurant without premium access cannot change user status
	
	Scenario: A restaurant cannot change the status of a complimentary user
	
	Scenario: An RIA admin comps a restaurant account with users
	
	Scenario: An RIA admin comps a user who is on a restaurant account