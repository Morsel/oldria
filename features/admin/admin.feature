Feature: Admin Interface
  So that staff can fix things, 
  As a Staff member 
  I want to edit user accounts
  And I want a single login that serves both Spoonfeed and Administrative purposes


  Scenario: Non-admin users get the boot
    Given I am logged in as a normal user
    When I go to the admin landing page
    Then I should see "This is an administrative area."
    And I should be on the homepage


  Scenario: Admin landing pages
    Given I am logged in as an admin
    When I go to the admin landing page
    Then I should see "Welcome back to work"


  Scenario: Editing User Accounts
    Given I am logged in as an admin
    When I go to the admin landing page
    And I follow "Users"
    Then I should see "All Users"
  