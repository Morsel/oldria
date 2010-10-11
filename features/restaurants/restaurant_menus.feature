@restaurant_menus
Feature: Restaurant Menus
  In order to find information about a restaurant's menus,
  I as a public user,
  would like to see the restaurant menus

  Background:
    Given I am logged in as an admin
    And a restaurant named "Bourgeois Pig"
    And the date and time is "now"

  Scenario: Upload a menu
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I fill in "January" for "Name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_pdf_remote_attachment_attributes_attachment"
    And I press "Upload"
    Then I should see a menu with the name "January" and change frequency "Monthly" and uploaded at date "now" 
    Then I should see a link to download the uploaded menu pdf "menu1.pdf"

  Scenario: Menu upload page does not display for a non-account manager
    Given I am logged in as a normal user
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I should see "You don't have permission to access that page"

  Scenario: Menu upload page does not display for a logged out user
    Given I am not logged in
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I should see "You must be logged in to access this page"

  Scenario: Upload a menu fails when name not entered
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_pdf_remote_attachment_attributes_attachment"
    And I press "Upload"
    Then I should not see any menus
    And I should see an error message

  Scenario: Upload a menu fails when change_frequency not specified
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I fill in "January" for "Name"
    And I attach the file "/features/images/menu1.pdf" to "menu_pdf_remote_attachment_attributes_attachment"
    And I press "Upload"
    Then I should not see any menus
    And I should see an error message

  Scenario: Upload a menu fails when file path not specified
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I fill in "January" for "Name"
    And I select "Monthly" from "How often it changes"
    And I press "Upload"
    Then I should not see any menus
    And I should see an error message

  Scenario: Upload a menu fails when file content type is other than PDF
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I fill in "January" for "Name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/bourgeoispig.jpg" to "menu_pdf_remote_attachment_attributes_attachment"
    And I press "Upload"
    Then I should not see any menus
    And I should see an error message

  Scenario: Remove a menu
    When I go to the restaurant menu upload page for Bourgeois Pig
    And I fill in "January" for "Name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_pdf_remote_attachment_attributes_attachment"
    And I press "Upload"
    Then I should have a menu with the name "January" and change frequency "Monthly"
    When I delete the menu with the name "January"
    Then I should not have a menu with the name "January" and change frequency "Monthly"

