@restaurant_images
Feature: Restaurant Images
  In order to better advertise a restaurant,
  I as a public user,
  would like to see the restaurant logo and photos

  Background:
    Given I am logged in as an admin
    And a restaurant named "Bourgeois Pig"

  Scenario: Upload a photo
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the file "/features/images/bourgeoispig.jpg" to "image_attachment"
    And I press "Upload"
    Then I see the uploaded restaurant photo

  @wip
  Scenario: Upload logo
    When I go to the admin edit restaurant page for Bourgeois Pig
    And I attach the file "/features/images/bourgeoispig.jpg" to "logo_attachment"
    And I press "Upload"
    Then I see the restaurant logo
