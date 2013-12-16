@restaurant
Feature: Manage restaurants
  In order to fix restaurant information and keep it accurate
  As an RIA Staff Member
  I want to be able to manage all restaurants and their information

  Background:
    Given a restaurant named "Piece" with the following employees:
      | username | password | email             | name           | role      |    
      | fred     | secret   | fred@testing.com  | Fred Mercury   | Chef      |
      | betty    | secret   | betty@testing.com | Betty Cobalt   | Sous chef |
    And I am logged in as an admin

  Scenario: I enter complete, valid data
    When I go to the admin edit restaurant page for Piece
    And I fill in the following:
      | Name                         | NeoPiece                            |
      | Tagline or short description | This is a modern cuisine restaurant |
      | Street Address               | 123 Sesame Street                   |
      | restaurant_street2           | Suite 200                           |
      | City                         | Paris                               |
      | State                        | TX                                  |
      | Zip                          | 12345                               |
      | Phone number                 | (312) 123-4567                      |
      | Website                      | http://www.restaurant.example.com   |
      # | Twitter Username             | piece_twitter                       |
      # | Facebook Page                | http://www.facebook.com/piece       |
      | Management company name      | Lettuce Entertain You               |
      | Management company website   | http://www.lettuce.com              |
    And I select "Fred Mercury" from "Media contact"
    And I select "2008-01-22" as the "Opening date" date
    And I press "Save"
    
    Then I should be on the admin restaurants page
    And I should see "NeoPiece"
    
    When I go to the restaurant show page for "NeoPiece"
    Then I see the following restaurant fields:
      | name               | NeoPiece                            |
      | description        | This is a modern cuisine restaurant |
      | address            | 123 Sesame Street                   |
      | address            | Suite 200                           |
      | address            | Paris                               |
      | address            | TX                                  |
      | address            | 12345                               |
      | phone_number       | (312) 123-4567                      |
      | website            | http://www.restaurant.example.com   |
      # | twitter_handle     | piece_twitter                       |
      # | facebook_page      | http://www.facebook.com/piece       |
      | media_contact      | Fred Mercury                        |
      | management_company | Lettuce Entertain You               |
      # | opening_date       | January 22, 2008                    |
    
@javascript
  Scenario: Making a basic restaurant complimentary
    Given the restaurant "Piece" does not have a premium account
    And I am on the admin restaurants page
    Then the listing for "Piece" should be basic
    When I go to the admin edit restaurant page for Piece
    And I should see that the restaurant has a basic account
    And I follow "Give restaurant a Complimentary Premium Account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a complimentary account
    When I am on the admin restaurants page
    And the listing for "Piece" should be complimentary
    
@javascript
  Scenario: Canceling a restaurant complimentary account
    Given the restaurant "Piece" has a complimentary account
    When I go to the admin edit restaurant page for Piece
    Then I should see that the restaurant has a complimentary account
    And I follow "Cancel the restaurant's Complimentary Premium Account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a basic account
    When I am on the admin restaurants page
    And the listing for "Piece" should be basic
    
@javascript
  Scenario: Converting an existing restaurant account to complementary
    Given the restaurant "Piece" has a premium account
    When I go to the admin edit restaurant page for Piece
    Then I should see that the restaurant has a premium account
    And I follow "Convert restaurant's premium account to a Complimentary Premium Account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a complimentary account
    When I am on the admin restaurants page
    And the listing for "Piece" should be complimentary
    
@javascript
  Scenario: Cancel a non-complimentary restaurant premium account
    Given the restaurant "Piece" has a premium account
    When I go to the admin edit restaurant page for Piece
    Then I should see that the restaurant has a premium account
    And I follow "Downgrade the restaurant to a Basic Account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a basic account
    When I am on the admin restaurants page
    And the listing for "Piece" should be basic
    
@javascript
  Scenario: Convert an overtime restaurant account to complimentary
    Given the restaurant "Piece" has an overtime account
    When I go to the admin edit restaurant page for Piece
    Then I should see that the restaurant has an overtime account
    And I follow "Convert restaurant's premium account to a Complimentary Premium Account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a complimentary account
    When I am on the admin restaurants page
    And the listing for "Piece" should be complimentary
  



