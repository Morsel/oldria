@payment
Feature: Restaurant Accounts
  So that a restaurant can create a premium account

  Background:
    Given a restaurant named "Taco Bell" with the following employees:
      | username | password | email            | name      | role      |
      | emily    | secret   | emily@example.com| Emily     | Manager   |
      | sam      | secret   | sam@example.com  | Sam Smith | Chef      |
      | john     | secret   | john@example.com | John Doe  | Sommelier |
    Given "emily" is a manager for "Taco Bell"
    Given "emily" is the account manager for "Taco Bell"
    Given I am logged in as "emily" with password "secret"

  Scenario: A basic restaurant can see its account status
    When I go to the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is basic
    And I see a link to update my account to premium

  Scenario: A premium restaurant can see their account status
    Given the restaurant "Taco Bell" has a premium account
    When I go to the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    And I see a link to cancel my account

  Scenario: A restaurant can enter payment info
    And I simulate a successful call from braintree for the restaurant "Taco Bell"
    And the restaurant "Taco Bell" does not have a premium account
    When I go to the edit restaurant page for "Taco Bell"
    And I follow "Upgrade to Premium"
    And I fill in the following:
      | Visa/Mastercard Number                | 4111111111111111     |
      | Billing Zip Code                      | 60654                |
      | Security Code                         | 123                  |
	And I select "10" from "customer_credit_card_expiration_month"
	And I select "2016" from "customer_credit_card_expiration_year"

  Scenario: Successful response from braintree makes a user premium
    When I simulate a successful call from braintree for the restaurant "Taco Bell"
    When I go to the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    And I see my restaurant account is paid for by myself

  Scenario: Unsuccessful response from braintree does not make a user premium
    When I simulate an unsuccessful call from braintree for the restaurant "Taco Bell"
    Then I should be on the new subscription page for the restaurant "Taco Bell"
    When I go to the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is basic

@javascript
  Scenario: A restaurant can cancel their premium account
    Given the restaurant "Taco Bell" has a premium account
    And I simulate a successful cancel from braintree
    When I go to the edit restaurant page for "Taco Bell"
    And I follow "Downgrade to basic"
    Then I should be on the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    And I see that the restaurant account for "Taco Bell" lasts until the end of the billing cycle
    And I do not see any account change options

@javascript
  Scenario: An unsuccessful cancel doesn't work for a restaurant
    Given the restaurant "Taco Bell" has a premium account
    And I simulate an unsuccessful cancel from braintree
    When I go to the edit restaurant page for "Taco Bell"
    And I follow "Downgrade to basic"
    Then I should be on the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    And I don't see that the restaurant account for "Taco Bell" lasts until the end of the billing cycle

  Scenario: You can't access a restaurant unless you are a manager
    Given I am logged in as "sam" with password "secret"
    When I go to the edit restaurant page for "Taco Bell"
    Then I should be on the restaurant show page for "Taco Bell"
    When I go to the new subscription page for the restaurant "Taco Bell"
    Then I should be on the restaurant show page for "Taco Bell"
    When I traverse the delete link for subscriptions for the restaurant "Taco Bell"
    Then I should be on the restaurant show page for "Taco Bell"

@javascript
  Scenario: An admin can access any restaurant
    Given the restaurant "Taco Bell" has a premium account
    Given I am logged in as an admin
    And I simulate a successful cancel from braintree
    When I go to the edit restaurant page for "Taco Bell"
    And I follow "Downgrade to basic"
    Then I should be on the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    And I see that the restaurant account for "Taco Bell" lasts until the end of the billing cycle
    And I do not see any account change options

  Scenario: A restaurant can update their payment info
    Given the restaurant "Taco Bell" has a premium account
    And I simulate braintree update behavior
    When I go to the edit restaurant page for "Taco Bell"
    When I follow "Update billing information"
    Then I should see my credit card information populated
    When I fill in the following:
      | Visa/Mastercard Number                | 4111111111111111     |
      | Billing Zip Code                      | 60654                |
      | Security Code                         | 123                  |
	And I select "10" from "customer_credit_card_expiration_month"
	And I select "2016" from "customer_credit_card_expiration_year"
    And I simulate a successful call from braintree for the restaurant "Taco Bell"
    Then I should be on the edit restaurant page for "Taco Bell"
    And I see that the restaurant's account status is premium

  Scenario: A restaurant can view their billing history
    Given the restaurant "Taco Bell" has a premium account
    And I simulate braintree search billing history behavior with the following:
      | transaction_id | amount | status  | date         | card_type | card_number | expiration_date |
      | abcd           | 50.00  | settled | 3.months.ago | Visa      | 1111        | 10/2012         |
      | efgh           | 50.00  | settled | 2.months.ago | Visa      | 1111        | 10/2012         |
      | ijkl           | 50.00  | settled | 1.months.ago | Visa      | 1111        | 10/2012         |
    When I go to the edit restaurant page for "Taco Bell"
    And I follow "View billing history"
    Then I should see all of my transaction details
