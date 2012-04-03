@newsfeed @restaurants
Feature: Newsfeed (restaurant promotions and events)
	So that Premium Restaurants can promote whats going on at their restaurant,
	create a new tab and form in the Restaurant Edit area for Restaurant account admins
	to insert promotional and event information.
	
  Background:
    Given a restaurant named "Fancy Lamb" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
    And I am logged in as "john"

	Given a promotion type named "Special Promotion"

  Scenario: a restaurant adds a new promotion
    When I go to the new promotion page for "Fancy Lamb"
    Then I should see "Newsfeed"

    When I select "Special Promotion" from "Promotion type"
    And I fill in "Details" with "My great event"
    And I fill in "Headline" with "Read all about it!"
	And I select "2012-03-12" as the "Start date" date
    And I press "Post"

    Then I should see "Your promotion has been created"
