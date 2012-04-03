@restaurant @restaurant_images
Feature: Restaurant Images
  In order to better advertise a restaurant,
  I as a public user,
  would like to see the restaurant logo and photos

  Background:
    Given a restaurant named "Piece"
    And a restaurant named "Bourgeois Pig"
    And I am logged in as a normal user
    And the user "normal" is employed by "Piece"
    And the user "normal" is an account manager for "Bourgeois Pig"

  Scenario: Upload a photo
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the file "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    Then I see the uploaded restaurant photo
    And I should see the uploaded restaurant photo credit

  Scenario: Photo upload page does not display for a non-account manager
    Given the user "normal" is not employed by "Bourgeois Pig"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I should see "You are not permitted to access this page"

  Scenario: Photo upload page does not display for a logged out user
    Given I am not logged in
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I should see "You must be logged in to access this page"

  Scenario: Upload a photo fails when no file specified
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    Then I see no restaurant photos
    And I should see an error message

  Scenario: Upload a photo fails when content type is not an image
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/menu1.pdf" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    Then I see no restaurant photos
    And I should see an error message

  Scenario: Upload a photo fails when credit is not filled in
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I press "Upload"
    Then I see no restaurant photos
    And I should see an error message

  Scenario: Upload logo
    When I go to the edit restaurant page for "Bourgeois Pig"
    And I attach the image "/features/images/bourgeoispig_logo.gif" to "restaurant_logo_attributes_attachment" on S3
    And I press "Save logo changes"
    When I go to the edit restaurant page for "Bourgeois Pig"
    Then I see the restaurant logo

  Scenario: Upload logo fails when content type is not an image
    When I go to the edit restaurant page for "Bourgeois Pig"
    And I attach the image "/features/images/menu1.pdf" to "restaurant[logo_attributes][attachment]" on S3
    And I press "Save logo changes"
    Then I should see a flash error message

  Scenario: Select Primary Photo
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig1.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig2.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I select the 2nd photo as the primary photo
    And I press "Save"
    When I go to the restaurant photo upload page for Bourgeois Pig
    Then I see the 2nd photo selected as the primary photo

  Scenario: First Photo Uploaded Is Automatically Selected As Primary Photo
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    Then I see the 1st photo selected as the primary photo
    When I go to the restaurant show page for "Bourgeois Pig"
    Then I should see that photo
  
  Scenario: Visit the photos page
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photos page for Bourgeois Pig
    Then I should see that photo

@javascript
  Scenario: Remove a restaurant photo
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig1.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig2.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    Then I should have a photo with the file "bourgeoispig.jpg"
    Then I should have a photo with the file "bourgeoispig1.jpg"
    Then I should have a photo with the file "bourgeoispig2.jpg"
    When I remove the restaurant photo with the file "bourgeoispig1.jpg"
    Then I should not have a photo with the file "bourgeoispig1.jpg"
    Then I should have a photo with the file "bourgeoispig.jpg"
    Then I should have a photo with the file "bourgeoispig2.jpg"

@javascript
  Scenario: Remove the restaurant logo
    When I go to the edit restaurant page for "Bourgeois Pig"
    And I attach the image "/features/images/bourgeoispig_logo.gif" to "restaurant_logo_attributes_attachment" on S3
    And I press "Save logo changes"
    When I go to the edit restaurant page for "Bourgeois Pig"
    And I remove the restaurant logo
    Then I should not see the restaurant logo

@javascript
  Scenario: Remove a restaurant photo that is the primary photo with other photos existing
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig1.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig2.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I select the 2nd photo as the primary photo
    And I press "Save"
    When I remove the restaurant photo with the file "bourgeoispig1.jpg"
    Then I see the 1st photo selected as the primary photo

@javascript
  Scenario: Remove a restaurant photo that is the primary photo and first photo in multiple
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig1.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig2.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I select the 1st photo as the primary photo
    And I press "Save"
    When I remove the restaurant photo with the file "bourgeoispig1.jpg"
    Then I see the 1st photo selected as the primary photo

@javascript
  Scenario: Remove a restaurant photo that is the primary photo and only photo
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the restaurant photo upload page for Bourgeois Pig
    And I select the 1nd photo as the primary photo
    And I press "Save"
    When I remove the restaurant photo with the file "bourgeoispig.jpg"
    Then I see no restaurant photos
