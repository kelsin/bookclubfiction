Feature: Status API
  In order to set the initial state of the application
  Clients will need to get the current status of nominations

  Scenario: Logged out status
    When I request "/status"
    Then the JSON at "logged_in" should be false

  Scenario: Logged in status
    Given a logged in user
    When I request "/status"
    Then the JSON at "logged_in" should be true
    Then the JSON at "user/name" should be "Test User"
    Then the JSON at "user/uid" should be 12345
    Then the JSON at "user/extra_votes" should be 5
    Then the JSON at "user/image" should be "image"

  Scenario: Without a current round
    Given a logged in user
    When I request "/status"
    Then the JSON should not have "current"