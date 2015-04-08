Feature: setText Operation
  In order to maintain a stable WebView setText Operation
  As a Calabash iOS maintainer
  I want some tests that demonstrate the API is working.

  @restart
  @restart_after
  Scenario: Input first name on UIWebView
    Given I am looking at the UIWebView tab
    And I can see the last name text input field
    When I touch the first name field, the keyboard should appear
    Then I should be able to use the setText API to set the text to "Moody"

  @restart
  @restart_after
  Scenario: Input first name on WKWebView
    Given I am looking at the WKWebView tab
    And I can see the last name text input field
    When I touch the first name field, the keyboard should appear
    Then I should be able to use the setText API to set the text to "Moody"
