@restaurant
Feature: Manage restaurants
  In order to fix restaurant information and keep it accurate
  As an RIA Staff Member
  I want to be able to manage all restaurants and their information

  Background:
    Given I am logged in as an admin
    Given a restaurant named "Piece" with the following employees:
      | username | password | email             | name           | role      |    
      | fred     | secret   | fred@testing.com  | Fred Mercury   | Chef      |
      | betty    | secret   | betty@testing.com | Betty Cobalt   | Sous chef |
    
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
      | Management Company Name      | Lettuce Entertain You               |
      | Management Company Website   | http://www.lettuce.com              |
    And I select "Fred Mercury" from "Media contact"
    And I select "January 22, 2008" as the date
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
      | twitter_username   | piece                               |
      | facebook_page      | http://www.facebook.com/piece       |
      | hours              | Mon-Sat 5-11pm                      |
      | media_contact      | Fred Mercury                        |
      | management_company | Lettuce Entertain You               |
      | opening_date       | January 22, 2008                    |

  Scenario: Upgrading an account to premium
    Given the following restaurant records:
      | name         | city    | state |
      | Piece        | Chicago | IL    |
    And I am on the admin restaurants page
    Then the listing for "Piece" should not be premium
    
    When I go to the restaurant show page for "Piece"
    Then the show page should not be premium
    
    When I am on the admin restaurants page
    When I follow "edit"
    And I check "Premium Account"
    # Otherwise the restaurant won't be valid to save
    And I select "Fred Mercury" from "Media contact"
    And I press "Save"
    
    Then I should see "updated restaurant"
    And the listing for "Piece" should be premium
    
    When I go to the restaurant show page for "Piece"
    Then the show page should be premium
    
  Scenario: Deleting a restaurant
    When I go to the admin restaurants page
    And I follow "destroy"
  
    Then I should see "Successfully removed restaurant"
    And I should not see "Piece"
    # Ensure users are converted to default (solo) employments
    And "fred" should have a primary employment with role "Chef"
    And "betty" should have a primary employment with role "Sous chef"
  
