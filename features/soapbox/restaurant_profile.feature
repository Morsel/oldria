@restaurant_profile
Feature: Restaurant profile
  So that a restaurant can see their profile

  Background:
    Given a restaurant named "Piece"
    And that "Piece" has a premium account
    And I am logged in as a normal user
    And the user "normal" is an account manager for "Piece"

  Scenario: Show basic data
    When I go to the restaurant photo upload page for Piece
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the edit restaurant page for "Piece"
    And I attach the image "/features/images/bourgeoispig_logo.gif" to "restaurant_logo_attributes_attachment" on S3
    And I press "Save logo changes"
    When I go to the restaurant menu upload page for Piece
    And I fill in "January" for "Menu name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_pdf_remote_attachment_attributes_attachment" on S3
    And I press "Upload"
    When I go to the restaurant menu upload page for Piece
    And I fill in "February" for "Menu name"
    And I select "Monthly" from "How often it changes"
    And I attach the file "/features/images/menu1.pdf" to "menu_pdf_remote_attachment_attributes_attachment" on S3
    And I press "Upload"
    When I go to the soapbox restaurant profile for "Piece"
    Then I see the restaurant's name linked as "Piece"
    And I see the restaurant's description
    And I see the address
    And I see the phone number
    And I see the restaurant's website as a link
    And I see the restaurant's Twitter username
    And I see the restaurant's Facebook page
    And I see media contact name, phone, and email
    And I see the management company name as a link
    And I see the primary photo
    And I see the restaurant logo for the profile
    And I see the restaurant menus
    And I see the opening date

  Scenario: Show management data without link if no link specified
    Given the restaurant has no website for its management company
    When I go to the soapbox restaurant profile for "Piece"
    Then I see the management company name without a link

  Scenario: Show no management data if not specified
    Given the restaurant has no management data
    When I go to the soapbox restaurant profile for "Piece"
    Then I do not see management data

  Scenario: The restaurant doesn't like social networking
    Given the restaurant has no Twitter of Facebook info
    When I go to the soapbox restaurant profile for "Piece"
    Then I do not see the Twitter username
    And I do not see the Facebook username

  Scenario: The restaurant has no menus uploaded
    When I go to the soapbox restaurant profile for "Piece"
    Then I should not see any menus
    And I should see "There are no menus available at this time."

  Scenario: Show primary photo detail view
    When I go to the restaurant photo upload page for Piece
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    When I go to the soapbox restaurant profile for "Piece"
    And I browse to the the primary photo detail view
    Then I should see the primary photo detail view
    And I should see "Xavier Zarope"

  Scenario: Show photo gallery
    When I go to the restaurant photo upload page for Piece
    And I attach the image "/features/images/bourgeoispig.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope" for "Credit"
    And I press "Upload"
    And I attach the image "/features/images/bourgeoispig1.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope I" for "Credit"
    And I press "Upload"
    And I attach the image "/features/images/bourgeoispig2.jpg" to "photo_attachment" on S3
    And I fill in "Xavier Zarope II" for "Credit"
    And I press "Upload"
    When I go to the soapbox restaurant profile for "Piece"
    And I follow "View all photos"
    Then I should see the restaurant photo gallery

  Scenario: Display message about no photos available when photo gallery is empty
    When I go to the soapbox restaurant profile for "Piece"
    Then I should not see any photos
    And I should see "There are no photos for this restaurant yet."

  Scenario: Show the public A La Minute Answers
    And "Piece" has answered the following A La Minute questions:
     | question        | answer    | public |
     | What's new?     | Nothing   | false  |
     | What's playing? | Blink 182 | true   |

    When I go to the soapbox restaurant profile for "Piece"
    Then I should see the question "What's playing" with the answer "Blink 182"
    And I should not see the question "What's new?" with the answer "Nothing"

  Scenario: The media contact should be a link
    Given the restaurant media contact has no phone number
    When I go to the soapbox restaurant profile for "Piece"
    And I see media contact name and email, but no phone

  Scenario: The media contact has a private phone number
    Given the restaurant media contact has a private phone number
    When I go to the soapbox restaurant profile for "Piece"
    And I see media contact name and email, but no phone

  Scenario: Only the most recent answer to a question should be shared publicly
    Given I am logged in as an admin
    And "Piece" has answered the following A La Minute questions:
     | question    | answer         | public |
     | What's new? | Lobster Bisque | true   |
     | What's new? | Pea Soup       | true   |

    And I go to the soapbox restaurant profile for "Piece"
    Then I should see the question "What's new?" with the answer "Pea Soup"
    And I should not see the answer "Lobster Bisque"

  Scenario: No display if not premium
    Given that "Piece" does not have a premium account
    When I go to the soapbox restaurant profile for "Piece"
    Then I should be on the soapbox index page