@newsletter
Feature: Newsletter
  As a public user of the site, I want to be able to subscribe to a daily newsletter
  
  Scenario: Signing up for the newsletter
    Given Mailchimp is set up
    When I go to the homepage
    And I fill in "Diner" for "first_name"
    And I fill in "Jones" for "last_name"
    And I fill in "myemail@mailserver.com" for "email"
    And I select "Diner" from "role"
    And I press "Sign Me Up"
    Then I should see "Thanks for signing up!"
    And "myemail@mailserver.com" should have 1 email

    When "myemail@mailserver.com" opens the email
    And I click the first link in the email
    Then I should see "Confirmed!"

    When I check "Sign me up for the Soapbox email newsletter!"
    And I press "Confirm"
    Then I should be on the edit newsletter subscriber page for "myemail@mailserver.com"
