@soapbox
Feature: Soapbox
  So that the public, diners, and media can get the inside story from chefs directly
  As a public user of the site
  I want to see QOTD and TRENDS as a public stream.


  Scenario: Featuring a QOTD on the soapbox
    Given there is a QOTD asking "Where do you buy flowers"
    And that QOTD has the following answers:
      | John Doeface  | I like to get them at the store |
      | Patty Wallace | Hand-picked, all the way!       |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Publish at | 2010-05-10 |
    Then there should be 1 QOTD on the soapbox landing page


