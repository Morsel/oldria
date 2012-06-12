@admin @messaging
Feature: Admin Messaging
  So that users can read admin messages
  And respond to them when appropriate

  Background:
  Given a restaurant named "No Man's Land" with the following employees:
    | username | name     | role | subject matters | email            |
    | johndoe  | John Doe | Chef | Food, Pastry    | johndoe@test.com |

# Replying to messages

 Scenario: Replying to a QOTD
   Given I am logged in as "johndoe"
   And "johndoe" has a QOTD message with:
     | message | Are lazy cakes cool? |
   When I go to the front burner page
   And I follow "Post"
   Then I should see "Are lazy cakes cool?"
   When I fill in "Post" with "Why, yes, they are quite cool!"
   And I press "Send"
   Then I should see "Thanks: your answer has been saved"

  Scenario: Replying to a published QOTD give a possibility to post on facebook
    Given I am logged in as "johndoe"
    And Facebook is functioning
    And given that user "johndoe" has facebook connection
    And there is a QOTD asking "Are lazy cakes cool?"
    And that QOTD is featured on the soapbox
    And that QOTD was sent to "johndoe"
    When I go to the front burner page
    And I follow "Post"

    When I fill in "Post" with "Why, yes, they are quite cool!"
    And I should see "Post to Facebook"
    And I check "Post to Facebook?"
    And I press "Send"
    Then I should see Facebook Share Popup
    And I should see "your answer has been saved"

  Scenario: Replying to a published Trend question give a possibility to post on facebook
    Given I am logged in as "johndoe"
    And Facebook is functioning
    And given that user "johndoe" has facebook connection
    And there is a Trend Question "Are cold cakes cool?: Weigh in now"
    And that Trend Question is featured on the soapbox
    And that Trend Question was sent to "No Man's Land"
    When I go to the front burner page
    And I follow "Post"

    When I fill in "Post" with "Why, yes, they are quite cool!"
    And I should see "Post to Facebook"
    And I check "Post to Facebook?"
    And I press "Send"
    Then I should see Facebook Share Popup

  Scenario: Editing a QOTD reply
    Given I am logged in as "johndoe"
    And "johndoe" has a QOTD message with:
      | message | Are lazy cakes cool? |
    And "johndoe" has commented on "Are lazy cakes cool?" with "Yes!"
    When I go to the front burner page
    And I follow "View your post"
    And I follow "Edit"
    And I fill in "Comment" with "Yes! They are totally cool."
    And I press "Save Comment"
    Then I should see "Updated comment"

  Scenario: PR Tips have no replies
    Given I am logged in as "johndoe"
    And "johndoe" has a PR Tip message with:
      | message | Never burn a burn notice |
    When I go to my inbox
    Then I should see "Never burn a burn notice"
    But I should not see "Quick Reply"

# Viewing scheduled messages

  Scenario: PR Tips and Announcements can be scheduled
    Given I am logged in as "johndoe"
    And "johndoe" has a PR Tip message with:
      | message      | This is a scheduled message |
      | scheduled_at | 2022-06-04 11:30:00         |
    When I go to my inbox
    Then I should not see "PR Tip"
    And I should not see "This is a scheduled message"

    When the date and time is "2022-06-04 11:45:00"
    And I go to my inbox
    Then I should see "This is a scheduled message"

  Scenario: Qotds can be scheduled
    Given I am logged in as "johndoe"
    And "johndoe" has a QOTD message with:
      | message      | This is a QOTD      |
      | scheduled_at | 2022-06-04 11:30:00 |
    When I go to the front burner page
    Then I should not see "Question of the Day"
    And I should not see "This is a QOTD"

    When the date and time is "2022-06-04 11:45:00"
    When I go to the front burner page
    Then I should see "This is a QOTD"

# New user woes

  Scenario: I have just confirmed my account and don't want to be overwhelmed by old with-replies messages
    Given a restaurant named "Fields of Plenty" with the following employees:
      | username   | name     | role | subject matters |
      | cleopatra  | Cleo Doe | Chef | Food, Wine      |
    And "cleopatra" has a QOTD message with:
      | message      | This is a new QOTD |
    And "cleopatra" has a QOTD message with:
      | message      | This is an old QOTD |
      | scheduled_at | 2010-06-03 12:00:00 |
    And QOTD "This is an old QOTD" has a reply "I reply!"
    And "cleopatra" has a trend question with:
      | subject      | This is an old trend question |
	  | body         | Old trend message             |
      | scheduled_at | 2010-06-06 12:00:00           |
    And trend question "This is an old trend question" has a reply "I reply here too!"
    And "Fields of Plenty" has a holiday reminder for holiday "Day Off" with:
      | message      | Don't bother to call in sick |
      | scheduled_at | 2010-06-02 12:00:00          |
    # And holiday "Day Off" has a reply "A reply for all holidays"
    And "cleopatra" has just been confirmed
    And I am logged in as "cleopatra"
    When I go to the front burner page
    Then I should see "This is a new QOTD"
    And I should not see "This is an old QOTD"
    And I should not see "This is an old trend question"
    And I should not see "Don't bother to call in sick"
    And "cleopatra" should have 2 QOTD messages

