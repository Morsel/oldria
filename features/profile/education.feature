@profile
Feature: Education
  Users can have none, one, or many of: 

  Name of culinary school, city, state, country

  Date of Graduation: HINT: "leave this blank if you did not graduate"
  Degree?
  Did you have any special focus?
  Did you receive any awards or special scholarships?


  Scenario: Adding a culinary school to your profile
  Given I am logged in as a normal user with a profile
    And I am on my profile's edit page
    And I follow "Résumé"
    When I add a culinary school to my profile with:
      | School Name     | Midwest International Food |
      | City            | Columbus                   |
      | State           | OH                         |
      | Graduation Year |                            |
    Then I should have 1 culinary school on my profile
    And I should see "Midwest International Food" on my profile page

  Scenario: Adding a normal school to your profile
  Given I am logged in as a normal user with a profile
    And I am on my profile's edit page
    And I follow "Résumé"
    When I add a nonculinary school to my profile with:
      | School Name     | Indiana University |
      | City            | Bloomington        |
      | State           | IN                 |
      | Graduation Year | 2002               |
    Then I should have 1 nonculinary school on my profile
    And I should see "Indiana University" on my profile page

