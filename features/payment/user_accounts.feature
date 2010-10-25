@payment
Feature: User Accounts
  So that a user can create a premium account

  Background:
    Given the following user records:
    | username | password |
    | emily    | secret   |
    | notemily | secret   |

  Scenario: A user can see their account status on their profile page
    Given I am logged in as "emily" with password "secret"
    When I go to the profile page for "emily"
    Then I do not see a premium badge
    When I go to the edit page for "emily"
    Then I see my account status is not premium
    And I see a link to update my account to premium

  Scenario: A premium user can see their account status
    Given user "emily" has a premium account
    Given I am logged in as "emily" with password "secret"
    When I go to the profile page for "emily"
    Then I see a premium badge
    When I go to the edit page for "emily"
    Then I see my account status is premium
    And I see a link to cancel my account

  @wip
  Scenario: A user can enter payment info
    Given I am logged in as "emily" with password "secret"
    And user "emily" does not have a premium account
    And I simulate braintree create behavior
    When I go to the edit page for "emily"
    And I follow "Upgrade to Premium"
    When I fill in the following:
      | Credit Card Number                    | 4111111111111111     |
      | Billing ZIP                           | 60654                |
      | customer_credit_card_expiration_month | 10                   |
      | customer_credit_card_expiration_year  | 1.year.from_now.year |
      | Security Code                         | 123                  |

  Scenario: Successful response from braintree makes a user premium
    Given I am logged in as "emily" with password "secret"
    When I simulate a successful call from braintree for user "emily"
    Then I should be on the edit page for "emily"
    Then I see my account status is premium
    And I see my account is paid for by myself

  Scenario: Unsuccessful response from braintree makes a user premium
    Given I am logged in as "emily" with password "secret"
    When I simulate an unsuccessful call from braintree for user "emily"
    Then I should be on the new subscription page
    When I go to the edit page for "emily"
    Then I see my account status is not premium

  Scenario: A user can cancel their payment info
    Given user "emily" has a premium account
    Given I am logged in as "emily" with password "secret"
    And I simulate a successful cancel from braintree
    When I go to the edit page for "emily"
    And I follow "Downgrade to basic"
    Then I should be on the edit page for "emily"
    Then I see my account status is not premium

  Scenario: An unsuccessful cancel doesn't work
    Given user "emily" has a premium account
    Given I am logged in as "emily" with password "secret"
    And I simulate an unsuccessful cancel from braintree
    When I go to the edit page for "emily"
    And I follow "Downgrade to basic"
    Then I should be on the edit page for "emily"
    Then I see my account status is premium

  Scenario: You can't access another user's account
    Given user "emily" has a premium account
    Given I am logged in as "notemily" with password "secret"
    When I go to the edit page for "emily"
    Then I should be on the root page
    When I go to the new subscription page for "emily"
    Then I should be on the root page
    When I traverse the delete link for subscriptions for user "emily"
    Then I should be on the root page

  Scenario: An admin can access another user's account
    Given user "emily" has a premium account
    And I am logged in as an admin
    And I simulate a successful cancel from braintree
    When I go to the edit page for "emily"
    And I follow "Downgrade to basic"
    Then I should be on the edit page for "emily"
    Then I see my account status is not premium

  Scenario: A user can update their payment info
    Given user "emily" has a premium account
    Given I am logged in as "emily" with password "secret"
    And I simulate braintree update behavior
    When I go to the edit page for "emily"
    When I follow "Update billing information"
    When I fill in the following:
      | Credit Card Number                    | 4111111111111111     |
      | Billing ZIP                           | 60654                |
      | customer_credit_card_expiration_month | 10                   |
      | customer_credit_card_expiration_year  | 1.year.from_now.year |
      | Security Code                         | 123                  |
    And I simulate a successful call from braintree for user "emily"
    Then I should be on the edit page for "emily"
    And I see my account status is premium
