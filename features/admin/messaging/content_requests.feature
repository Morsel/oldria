# @admin @messaging
# Feature: Content Requests (Questions from RIA)
# 
#   Background:
#     Given a restaurant named "Normal Pants" with the following employees:
#       | username | password | email            | name      | role      | subject matters |
#       | sam      | secret   | sam@example.com  | Sam Smith | Chef      | Food, Pastry    |
#       | jim      | secret   | jim@example.com  | Jim Smith | Assistant | Beer            |
#     Given a restaurant named "Fancy Lamb" with the following employees:
#       | username | password | email            | name      | role      | subject matters |
#       | john     | secret   | john@example.com | John Doe  | Sommelier | Beer, Wine      |
#     And the restaurant "Normal Pants" is in the region "Midwest"
#     And the restaurant "Fancy Lamb" is in the region "Southwest"
# 
# @emails
#   Scenario: New Content Request notification, user prefers no emails
#     Given I am logged in as an admin
#     And "sam" prefers to not receive direct message alerts
#     When I create a new content request with subject "Need Your Menu" with criteria:
#       | Region | Midwest (IN IL OH) |
#       | Role   | Chef               |
#     Then the content request with subject "Need Your Menu" should have 1 restaurant
#     And the last content request for "Normal Pants" should be viewable by "Sam Smith"
#     And "sam@example.com" should have no emails
# 
# @emails 
#   Scenario: New Content Request notification, user prefers emails
#     Given "sam" prefers to receive direct message alerts
#     Given I am logged in as an admin
#     When I create a new content request with subject "Need Your Menu" with criteria:
#       | Region | Midwest (IN IL OH) |
#       | Role   | Chef               |
#     Then the content request with subject "Need Your Menu" should have 1 restaurant
#     And the last content request for "Normal Pants" should be viewable by "Sam Smith"
#     And "sam@example.com" should have 1 email
# 
#     Given "jim" is the account manager for "Normal Pants"
#     And I am logged in as "jim" with password "secret"
#     When I go to my inbox
#     And I follow "Post"
#     And I fill in "Post" with "But my river is green"
#     And I press "Send"
# 
#     Then "sam@example.com" should have 2 emails