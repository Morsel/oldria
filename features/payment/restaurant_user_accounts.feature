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

@javascript
  Scenario: A premium restaurant adds a user without a premium account
    Given I simulate a successful addon response from Braintree with 1
    When I go to the employees page for "Taco Bell"
    When I follow the edit role link for "Sam Smith"
    Then I see that "sam" has a basic account
    When I follow "Upgrade employee account to Premium"
    Then I should be on the employee edit page for "Taco Bell" and "sam"
    And I see that "sam" has a premium account paid for by the restaurant

@javascript
  Scenario: A premium restaurant adds a second user without a premium account
    Given I simulate a successful addon response from Braintree with 2
    And user "john" has a restaurant staff account from "Taco Bell"
    When I go to the employees page for "Taco Bell"
    When I follow the edit role link for "Sam Smith"
    Then I see that "sam" has a basic account
    When I follow "Upgrade employee account to Premium"
    Then I should be on the employee edit page for "Taco Bell" and "sam"
    And I see that "sam" has a premium account paid for by the restaurant

@javascript
  Scenario: A premium restaurant cancels a user with a staff account
    Given I simulate a successful addon response from Braintree with 1
    And user "john" has a restaurant staff account from "Taco Bell"
    And user "sam" has a restaurant staff account from "Taco Bell"
    When I go to the employees page for "Taco Bell"
    And I follow the edit role link for "Sam Smith"
    And I follow "Cancel user Premium Account immediately"
    Then I should be on the employee edit page for "Taco Bell" and "sam"
    And I see that "sam" does not have a premium account paid for by the restaurant

@javascript
  Scenario: A premium restaurant adds a user that already has a premium account
    Given I simulate a successful addon response from Braintree with 1
    And I simulate a required successful cancel from braintree
    Given user "sam" has a premium account
    When I go to the employees page for "Taco Bell"
    When I follow the edit role link for "Sam Smith"
    Then I see that "sam" has a premium account of his own
    When I follow "Add employee Premium Account to your account"
    Then I should be on the employee edit page for "Taco Bell" and "sam"
    And I see that "sam" has a premium account paid for by the restaurant

@javascript
  Scenario: A premium restaurant with accounts cancels its account
    Given I simulate a successful cancel from braintree
    And user "john" has a restaurant staff account from "Taco Bell"
    And user "sam" has a complimentary premium account
    When I go to the edit restaurant page for "Taco Bell"
    And I follow "Downgrade to basic"
    Then I should be on the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    And I see that the restaurant account for "Taco Bell" lasts until the end of the billing cycle
    And I do not see any account change options

    Given I am logged in as an admin
    When I go to the admin edit page for "john"
    Then I see my account status is premium
    And I see that the account for "john" lasts until the end of the billing cycle
    When I go to the admin edit page for "sam"
    Then I see my account status is complimentary
    And I don't see that the account for "sam" lasts until the end of the billing cycle

  Scenario: A non premium restaurant doesn't see the button
    Given the restaurant "Taco Bell" does not have a premium account
    When I go to the employees page for "Taco Bell"
    When I follow the edit role link for "Sam Smith"
    Then I do not see a link to change the user status

  Scenario: A complimentary restaurant adds a user without a premium account
    Given the restaurant "Taco Bell" has a complimentary premium account
    Given I simulate braintree create behavior
    When I go to the employees page for "Taco Bell"
    When I follow the edit role link for "Sam Smith"
    Then I see the information to enter billing
    When I follow "Upgrade to Restaurant Account"
    Then I should be on the new subscription page for the restaurant "Taco Bell"
    When I fill in the following:
      | Visa/Mastercard Number                | 4111111111111111     |
      | Billing Zip Code                      | 60654                |
      | Security Code                         | 123                  |
	And I select "10" from "customer_credit_card_expiration_month"
	And I select "2016" from "customer_credit_card_expiration_year"

  Scenario: Successful response from braintree makes a user premium
    When I simulate a successful call from braintree for the restaurant "Taco Bell"
    When I go to the employees page for "Taco Bell"
    When I follow the edit role link for "Sam Smith"
    Then I should see "Upgrade employee account to Premium"

  Scenario: A restaurant cannot change the status of a complimentary user
    Given the restaurant "Taco Bell" has a premium account
    And user "sam" has a complimentary premium account
    When I go to the employees page for "Taco Bell"
    And I follow the edit role link for "Sam Smith"
    And I do not see a link to change the user status

  Scenario: A user who is a staff account can't change status
    Given the restaurant "Taco Bell" has a premium account
    And user "emily" has a staff account for the restaurant "Taco Bell"
    When I go to the edit page for "emily"
    And I follow "Account" within "#profile-tabs"
    Then I see my account status is a premium staff account
    And I do not see any account change options

@javascript
  Scenario: An RIA admin comps a restaurant account with users
    Given the restaurant "Taco Bell" has a premium account
    And user "emily" has a staff account for the restaurant "Taco Bell"
    And I simulate a successful braintree update for "Taco Bell" with the complimentary discount

    Given I am logged in as an admin
    When I go to the admin edit restaurant page for Taco Bell
    And I follow "Convert restaurant's premium account to a Complimentary Premium Account"
    Then I should be on the admin edit restaurant page for Taco Bell
    Then I should see that the restaurant has a complimentary account

@javascript
  Scenario: An RIA admin comps a user who is on a restaurant account
    Given the restaurant "Taco Bell" has a premium account
    And I simulate a successful addon response from Braintree with 1
    And user "emily" has a staff account for the restaurant "Taco Bell"
    And user "sam" has a staff account for the restaurant "Taco Bell"

    Given I am logged in as an admin
    When I go to the admin edit page for "sam"
    And I follow "Convert user's premium account to a Complimentary Premium Account"
    Then I should be on the admin edit page for "sam"
    Then I should see that the user has a complimentary account

@javascript
  Scenario: An RIA admin cancels a restaurant account with users
    Given the restaurant "Taco Bell" has a premium account
    And user "emily" has a staff account for the restaurant "Taco Bell"
    And I simulate a required successful cancel from braintree

    Given I am logged in as an admin
    When I go to the admin edit restaurant page for Taco Bell
    And I follow "Downgrade the restaurant to a Basic Account"
    Then I should be on the admin edit restaurant page for Taco Bell
    Then I should see that the restaurant has a basic account
    When I go to the admin edit page for "emily"
    Then I see my account status is basic

@javascript
  Scenario: An RIA admin cancels a user who is on a restaurant account
    Given the restaurant "Taco Bell" has a premium account
    And I simulate a successful addon response from Braintree with 1
    And user "emily" has a staff account for the restaurant "Taco Bell"
    And user "sam" has a staff account for the restaurant "Taco Bell"

    Given I am logged in as an admin
    When I go to the admin edit page for "sam"
    And I follow "Downgrade the user to a Basic Account"
    Then I should be on the admin edit page for "sam"
    Then I should see that the user has a basic account

  Scenario: A user at multiple restaurants only is staff at one of them
    Given the restaurant "Taco Bell" has a premium account
    And user "emily" has a staff account for the restaurant "Taco Bell"
    And a restaurant named "Burger King" with the following employees:
      | username | password | email            | name      | role      |
      | king     | secret   | king@example.com | king      | Manager   |
    Given the restaurant "Burger King" has a premium account
    Given "king" is a manager for "Burger King"
    Given "king" is the account manager for "Burger King"
    And "emily" is an employee of "Burger King"
    When I go to the employees page for "Taco Bell"
    When I follow the edit role link for "Emily Emily"
    And I see that "emily" has a premium account paid for by the restaurant

    Given I am logged in as "king" with password "secret"
    When I go to the employees page for "Burger King"
    When I follow the edit role link for "Emily Emily"
    And I see that "emily" has a premium account paid for by a different restaurant
    And I do not see a link to change the user status
