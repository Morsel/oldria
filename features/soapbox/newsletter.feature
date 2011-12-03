@soapbox @newsletter
Feature: Soapbox - Newsletter
  As a public user of the site, I want to be able to subscribe to a daily newsletter
  
  Scenario: Signing up for the newsletter
    When I go to the soapbox index page
    And I fill in "myemail@mailserver.com" for "newsletter_subscriber_email"
    And I press "Subscribe"
    Then I should see "Thanks for signing up!"