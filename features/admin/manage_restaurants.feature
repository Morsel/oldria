@restaurant
Feature: Manage restaurants
  In order to fix restaurant information and keep it accurate
  As an RIA Staff Member
  I want to be able to manage all restaurants and their information


  Background:
    Given I am logged in as an admin
    And a restaurant named "Piece"
    And the following media users:
      | username | password | first_name | last_name |
      | fred     | secret   | Fred       | Mercury   |
      | betty    | secret   | Betty      | Rubble    |
    And "fred" is an employee of "Piece"
    And "betty" is an employee of "Piece"
    
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
      | Phone Number                 | (312) 123-4567                      |
      | Website                      | http://www.restaurant.example.com   |
      | Twitter Username             | piece                               |
      | Facebook Page                | http://www.facebook.com/piece       |
      | Hours                        | Mon-Sat 5-11pm                      |
      | Management Company Name      | Lettuce Entertain You          |
      | Management Company Website   | http://www.lettuce.com      |
    And I select "Fred Mercury" from "Media contact"
    When I select "Janaury 22, 2008" as the date
    And I press "Save"
    And I should be on the admin restaurants page
    And I should see "NeoPiece"
    And I go to the restaurant show page for "NeoPiece"
    And I see the following restaurant fields:
      | name               | NeoPiece                            |
      | description        | This is a modern cuisine restaurant |
      | address            | 123 Sesame Street                   |
      | address            | Suite 200                           |
      | address            | Paris                               |
      | address            | TX                                  |
      | address            | 12345                               |
      | phone_number       | (312) 123-4567                      |
      | website            | http://www.restaurant.example.com   |
      | twitter_username   | piece                               |
      | facebook_page      | http://www.facebook.com/piece       |
      | hours              | Mon-Sat 5-11pm                      |
      | media_contact      | Fred Mercury                        |
      | management_company | Lettuce Entertain You               |
      | opening_date       | January 22, 2008                    |
    
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
    When I go to the restaurant show page for "Piece"
    Then the show page should be premium
    
  Scenario: Canceling a restaurant complimentary account
    Given the restaurant "Piece" has a complimentary account
    When I go to the admin edit restaurant page for Piece
    Then I should see that the restaurant has a complimentary account
    And I follow "Cancel the restaurant's Complimentary Premium Account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a basic account
    When I am on the admin restaurants page
    And the listing for "Piece" should be basic
    When I go to the restaurant show page for "Piece"
    Then the show page should be basic
    
  Scenario: Converting an existing restaurant account to complementary
    Given the restaurant "Piece" has a premium account
    When I go to the admin edit restaurant page for Piece
    Then I should see that the restaurant has a premium account
    And I follow "Convert restaurant's premium account to a Complimentary Premium Account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a complimentary account
    When I am on the admin restaurants page
    And the listing for "Piece" should be complimentary
    When I go to the restaurant show page for "Piece"
    Then the show page should be premium
    
  Scenario: Cancel a non-complimentary restaurant premium account
    Given the restaurant "Piece" has a premium account
    When I go to the admin edit restaurant page for Piece
    Then I should see that the restaurant has a premium account
    And I follow "Downgrade the restaurant to a basic account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a basic account
    When I am on the admin restaurants page
    And the listing for "Piece" should be basic
    When I go to the restaurant show page for "Piece"
    Then the show page should be basic
    
  Scenario: Convert an overtime restaurant account to complimentary
    Given the restaurant "Piece" has an overtime account
    When I go to the admin edit restaurant page for Piece
    Then I should see that the restaurant has an overtime account
    And I follow "Convert restaurant's premium account to a Complimentary Premium Account"
    Then I should be on the admin edit restaurant page for Piece
    Then I should see that the restaurant has a complimentary account
    When I am on the admin restaurants page
    And the listing for "Piece" should be complimentary
    When I go to the restaurant show page for "Piece"
    Then the show page should be premium
  
  #Scenario: Cancel an overtime restaurant account
    
