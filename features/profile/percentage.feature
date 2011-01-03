@profile @btl
Feature: Profile - Behind the Line - Answers percentage stats
  SF users should see % of completeness for chapters and topics

  Background:
  Given the following confirmed users:
    | username    | password | first_name | last_name |
    | punkrock    | secret   | John       | Smith     |
  And the following profile questions with chapters, topics and answers for "punkrock":
    | title       | chapter     | topic      | answer |
    | Question0   | Show        | Favorites  |        | 
    | Question1   | Common      | Profile    | yes    |
    | Question2   | Common      | Profile    | yes    |
    | Question3   | About       | Profile    |        |
    | Question4   | Bosses      | Career     | yes    |
    | Question5   | Experience  | Career     |        |
    | Question6   | Places      | Life       | yes    |
  And I am logged in as "punkrock"
  Given "punkrock" has a complimentary premium account
  And "punkrock" has a published profile

  Scenario: I should see % of completeness for each chapter on profile page
    Given I am on the profile page for "punkrock"
    And I should see "Favorites (0% complete)"
    And I should see "Profile (66% complete)"
    And I should see "Career (50% complete)"
    And I should see "Life (100% complete)"
