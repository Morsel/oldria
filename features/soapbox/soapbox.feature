@soapbox
Feature: Soapbox
  So that the public, diners, and media can get the inside story from chefs directly
  As a public user of the site
  I want to see QOTD and TRENDS as a public stream.

  Scenario: Featuring a QOTD on the soapbox
    Given there is a QOTD asking "Where do you buy flowers?"
    And that QOTD has the following answers:
      | John Doeface  | I like to get them at the store |
      | Patty Wallace | Hand-picked, all the way!       |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-05-10 |
    Then there should be 1 QOTD on the soapbox front burner page
    
  Scenario: Viewing a QOTD soapbox entry title
    Given there is a QOTD asking "Where do you buy flowers?"
    And that QOTD has the following answers:
      | John Doeface  | I like to get them at the store |
      | Patty Wallace | Hand-picked, all the way!       |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-05-10 |
    Then there should be 1 QOTD on the soapbox front burner page

  Scenario: Featuring links to other questions on the question page within the soapbox front burner
    Given there is a QOTD asking "Where do you buy flowers"
    And that QOTD is featured on the soapbox
    And there is a Trend Question "What is the haps?: Boo-ya"
    And that Trend Question is featured on the soapbox
    When I selected corresponding soapbox entry
    Then I should see "Trend Questions" within "aside"
    And I should see "Questions of the Day" within "aside"
    And I should see "View all" within "aside"

  Scenario: Featuring all QOTDs on a separate page
    Given there is a QOTD asking "How do you boil ketchup"
    And that QOTD has the following answers:
      | Archibald Goodwill | I like to get them at the store |
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-12-06 |
    Given there is a QOTD asking "How do you freeze ketchup"
    And that QOTD has the following answers:
      | Andrew Gotzky | I like to move it |
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-12-06 |
    And I go to the all of the qotd questions listing page
    Then I should see "Questions of the Day" within "#all-questions"
    And I should see "How do you boil ketchup" within "#all-questions-feed"
    And I should see "How do you freeze ketchup" within "#all-questions-feed"

  Scenario: Featuring all Trends on a separate page
    Given there is a Trend Question "The best ketchup in the world"
    And that Trend Question is featured on the soapbox
    Given there is a Trend Question "Hot water supplier"
    And that Trend Question is featured on the soapbox
    When I go to the all of the trend questions listing page
    Then I should see "Trend Questions" within "#all-questions"
    And I should see "The best ketchup in the world" within "#all-questions-feed"
    And I should see "Hot water supplier" within "#all-questions-feed"

  Scenario: Viewing the addThis button
    Given the following published users:
    | username    | password |
    | punkrock    | secret   |
    And I am on the profile page for "punkrock"
    Then I should see addThis button

  Scenario: Viewing a QOTD soapbox entry title
    Given there is a QOTD asking "Where do you buy flowers"
    And that QOTD is featured on the soapbox
    #When I selected corresponding soapbox entry
    #Then I should see "Where do you buy flowers - Soapbox Question of the Day" within "title"
    When I follow "Where do you buy flowers?"
    Then I should see "Where do you buy flowers? - Soapbox Question of the Day" within "title"

  Scenario: Viewing a Trend Question soapbox entry title
    Given there is a Trend Question "What is the haps?: Boo-ya"
    And that Trend Question is featured on the soapbox
    When I selected corresponding soapbox entry
    Then I should see "What is the haps?: Boo-ya - Soapbox Trend" within "title"

  Scenario: Viewing the addThis button on front_burner page
    Given there is a QOTD asking "Where do you buy flowers"
    And that QOTD is featured on the soapbox
    And there is a Trend Question "What is the haps?: Boo-ya"
    And that Trend Question is featured on the soapbox
    When Visit to front_burner
    Then I should see two addThis buttons
<<<<<<< HEAD





=======
  
  Scenario: Viewing a Trend Question soapbox entry title
    Given there is a Trend Question "What is the haps?: Boo-ya"
    And I am logged in as an admin
    When I create a new soapbox entry for that Trend Question with:
      | Published at | 2010-05-10 |
  
    When I go to the soapbox front burner page
    And I follow "What is the haps?: Boo-ya"
    Then I should see "What is the haps?: Boo-ya - Soapbox Trend" within "title"
    
  Scenario: Viewing the addThis button on front_burner page
    Given there is a QOTD asking "Where do you buy flowers?"
    And I am logged in as an admin
    When I create a new soapbox entry for that QOTD with:
      | Published at | 2010-05-10 |
    And there is a Trend Question "What is the haps?: Boo-ya"
    When I create a new soapbox entry for that Trend Question with:
      | Published at | 2010-05-10 |
    
    When I go to the soapbox front burner page
    Then I should see "Where do you buy flowers?"
    And I should see "What is the haps?: Boo-ya"
    And I should see two addThis buttons
>>>>>>> master
>>>>>>> 50d9aa3dc31f2476393cd4945c053b4c0564e314
