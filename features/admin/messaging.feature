@admin @messaging
Feature: Admin Messaging

  Background:
  Given a restaurant named "No Man's Land" with the following employees:
    | username | name     | role | subject matters |
    | johndoe  | John Doe | Chef | Food, Pastry    |


  Scenario: Replying to a QOTD
    Given I am logged in as "johndoe"
    And "johndoe" has a QOTD message with:
      | message | Are lazy cakes cool? |
    When I go to my inbox
    And I follow "Reply"
    Then I should see "Are lazy cakes cool?"

    When I fill in "Reply" with "Why, yes, they are quite cool!"
    And I press "Send"
    Then I should see "Why, yes, they are quite cool!"
    And I should see "Successfully created"


  Scenario: PR Tips have no replies
    Given I am logged in as "johndoe"
    And "johndoe" has a PR Tip message with:
      | message | Never burn a burn notice |
    When I go to my inbox
    Then I should see "Never burn a burn notice"
    But I should not see "Reply"


  Scenario: Content Requests have replies with attachments
    Given I am logged in as "johndoe"
    And "johndoe" has a Content Request message with:
      | message | Can I have your facebook pic? |
    When I go to my inbox
    Then I should see "Can I have your facebook pic?"

    When I follow "Reply"
    And I fill in "Reply" with "Here it is"
    And I attach an avatar "headshot.jpg" to "Attachment"
    And I press "Send"
    Then I should see "Successfully created"


  Scenario: PR Tips and Announcements can be scheduled
    Given I am logged in as "johndoe"
    And "johndoe" has a PR Tip message with:
      | message      | This is a scheduled message |
      | scheduled_at | 2010-06-04 11:30:00         |
    When I go to my inbox
    Then I should not see "PR Tip"
    And I should not see "This is a scheduled message"

    When the date and time is "2010-06-04 11:45:00"
    And I go to my inbox
    Then I should see "This is a scheduled message"


  Scenario: Qotds can be scheduled
    Given I am logged in as "johndoe"
    And "johndoe" has a QOTD message with:
      | message      | This is a QOTD      |
      | scheduled_at | 2010-06-04 11:30:00 |
    When I go to my inbox
    Then I should not see "Question of the Day"
    And I should not see "This is a QOTD"

    When the date and time is "2010-06-04 11:45:00"
    And I go to my inbox
    Then I should see "This is a QOTD"
