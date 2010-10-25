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
  
  @wip  
  Scenario: A restaurant's account status shows on its profile page
    Given I am logged in as "emily" with password "secret"
    When I go to the restaurant show page for "Taco Bell"
    Then I see that the restaurant's account status is basic
    When I go to the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is basic
    And I see a link to update my account to premium
    
  @wip
  Scenario: A premium restaurant can see their account status
    Given the restaurant "Taco Bell" has a premium account
    When I go to the restaurant show page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    When I go to the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    And I see a link to cancel my account
    
  @wip  
  Scenario: A restaurant can enter payment info
    And I simulate a successful call from braintree for the restaurant "Taco Bell"
    And the restaurant "Taco Bell" does not have a premium account
    When I go to the edit restaurant page for "Taco Bell"
    And I follow "Upgrade to Premium"
    And I fill in the following:
      | Credit Card Number                    | 4111111111111111     |
      | Billing ZIP                           | 60654                |
      | customer_credit_card_expiration_month | 10                   |
      | customer_credit_card_expiration_year  | 1.year.from_now.year |
      | Security Code                         | 123                  |
      
  @wip
  Scenario: Successful response from braintree makes a user premium
    When I simulate a successful call from braintree for the restaurant "Taco Bell"
    When I go to the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is premium
    And I see my account is paid for by myself
    
  @wip
  Scenario: Unsuccessful response from braintree does not make a user premium
    When I simulate an unsuccessful call from braintree for the restaurant "Taco Bell"
    Then I should be on the new subscription page
    When I go to the edit restaurant page for "Taco Bell"
    Then I see that the restaurant's account status is basic
    