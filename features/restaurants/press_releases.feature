@press_release @restaurants
Feature: Press Releases
	So that restaurant publicists can share information about the restaurant,
	they should be able to upload a press release PDF and have it display on the
	restaurant profile.
	
  Background:
	Given a restaurant named "Meagerff Lamb" with the following employees:
      | username | password | email            | name      | role      | subject matters |
      | jane     | secret   | jane@example.com | Jane Doe  | Publicist | Business        |
    And I am logged in as "jane"


  Scenario: a restaurant adds a new press release
    When I go to the edit restaurant page for "Meager Lamb"
	And I follow "Press Releases"
	Then I should see "Add a press release"

	When I fill in "New hours!" for "Press release title"
	And I attach the file "/features/images/menu1.pdf" to "press_release_pdf_remote_attachment_attributes_attachment" on S3
    And I press "Upload"
	Then I should see "saved"
	And I should see "New hours!" within "table#press_releases"
