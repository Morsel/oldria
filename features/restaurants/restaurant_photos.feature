@restaurant_photos
Feature: Restaurant Photos
  In order to better advertise a restaurant,
  I as the public user,
  would like to see restaurant photos

  Background:
    Given I am logged in as an admin
    And a restaurant named "Bourgeois Pig"

  Scenario: Show basic data
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the file "/features/images/bourgeoispig.jpg" to "image_attachment"
    And I press "Upload"
    Then I see the uploaded restaurant photo
