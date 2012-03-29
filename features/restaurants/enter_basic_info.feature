@restaurant @restaurant_profile
Feature: Basic Restaurant Data
  As a restaurant manager, I can edit basic info about my restaurant
  http://www.pivotaltracker.com/story/show/5227733


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
    When I go to the edit restaurant page for "Piece"
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
      # | Twitter Username             | piece                               |
      # | Facebook Page                | http://www.facebook.com/piece       |
      | Management company name      | Lettuce Entertain You               |
      | Management company website   | http://www.lettuce.com              |
    And I select "Fred Mercury" from "Media contact"
    When I select "2008-01-22" as the "Opening date" date
    And I press "Save changes"
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
      # | twitter_handle     | piece                               |
      # | facebook_page      | http://www.facebook.com/piece       |
      | media_contact      | Fred Mercury                        |
      | management_company | Lettuce Entertain You               |
      # | opening_date       | January 22, 2008                    |

  Scenario: Unhappy data
    When I remove optional information from the restaurant
    And I go to the restaurant show page for "Piece"
    # And I do not see a section for "twitter_username"
    # And I do not see a section for "facebook_page"
    And I do not see a section for "management_company"
