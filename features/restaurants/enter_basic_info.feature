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
      | betty    | secret   | Betty      | Rubble   |

  Scenario: I enter complete, valid data
    When I go to the edit restaurant page for "Piece"
    And I fill in the following:
      | Name               | NeoPiece                            |
      | Description        | This is a modern cuisine restaurant |
      | Street Address     | 123 Sesame Street                   |
      | restaurant_street2 | Suite 200                           |
      | City               | Paris                               |
      | State              | TX                                  |
      | Zip                | 12345                               |
      | Phone Number       | (312) 123-4567                      |
      | Website            | http://www.restaurant.example.com   |
      | Twitter Username   | piece                               |
      | Facebook Page      | http://www.facebook.com/piece       |
      | Hours              | Mon-Sat 5-11pm                      |
      | Management Company Name | Lettuce Entertain You          |
      | Management Company Website | http://www.lettuce.com      |
    And I select "Fred Mercury" from "Media contact"
    And I press "Save"
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

  Scenario: Unhappy data
    When I remove optional information from the restaurant
    And I go to the restaurant show page for "Piece"
    Then I do not see a section for "website"
    And I do not see a section for "twitter_username"
    And I do not see a section for "facebook_page"
    And I do not see a section for "management_company"


