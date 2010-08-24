@profile
Feature: Education
  Users can have none, one, or many of: 

  Name of culinary school, city, state, country

  Date of Graduation: HINT: "leave this blank if you did not graduate"
  Degree?
  Did you have any special focus?
  Did you receive any awards or special scholarships?


  Scenario: Adding a culinary school to your profile
    Given I am logged in as a normal user
    And I am on my profile's edit page
    When I add a culinary school to my profile with:
      | School Name     | Midwest International Food |
      | City            | Columbus                   |
      | State           | OH                         |
      | Graduation Date |                            |
    Then I should have 1 culinary school on my profile
    And I should see "Midwest International Food" on my profile page
