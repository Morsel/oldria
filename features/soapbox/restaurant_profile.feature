@restaurant_profile
Feature: Restaurant profile
  So that a restaurant can see their profile

  Background:
    Given a restaurant named "Piece"

  @wip
  Scenario: Show basic data
    When I go to the soapbox restaurant profile for Piece
    Then I see the restaurant's name as "Piece"
    And I see the restaurant's description
#    And I see the management company name
    And I see the address
    And I see the phone number
    And I see the restaurant's website
    And I see the restaurant's Twitter username
    And I see the restaurant's Facebook page
    And I see the restaurant's hours
    And I see media contact name, phone, and email