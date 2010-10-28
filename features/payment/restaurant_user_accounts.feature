@payment
Feature: Restaurant Accounts
  So that a restaurant can add it's users as premium accounts
  
  Background:
    Given a restaurant named "Taco Bell" with the following employees:
      | username | password | email            | name      | role      |
      | emily    | secret   | emily@example.com| Emily     | Manager   |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      |
      | john     | secret   | john@example.com | John Doe  | Sommelier |
    Given the restaurant "Taco Bell" has a premium account
    Given "emily" is a manager for "Taco Bell"
    Given "emily" is the account manager for "Taco Bell"
    Given I am logged in as "emily" with password "secret"
  
  @wip
	Scenario: A premium restaurant adds a user without a premium account
	  Given I simulate a successful addon response from Braintree
		When I go to the employees page for "Taco Bell"
		When I follow the edit role link for "Sam Smith"
		Then I see that "sam" has a basic account
		When I follow "Upgrade employee account to premium"
		Then I should be on the employee edit page for "Taco Bell" and "sam"
		And I see that "sam" has a premium account
		
	Scenario: A non premium restaurant doesn't see the button
	
	Scenario: A complimentary restaurant adds a user without a premium account
	
	Scenario: A complimentary restaurant adds a second user without a premium account
	
	Scenario: A premium restaurant adds a user that already has a premium account
		
	
	Scenario: A restaurant without premium access cannot change user status
	
	Scenario: A restaurant cannot change the status of a complimentary user
	
	Scenario: An RIA admin comps a restaurant account with users
	
	Scenario: An RIA admin comps a user who is on a restaurant account
	
	# cancel notes
	
	#Scenario: A user whose account is being paid for cannot cancel or update	
	
	# user's subscription gets cancelled
	# add on
	
	
	