Feature: dump route
  In order to maintain a stable dump route API on web views.
  As a Calabash iOS maintainer
  I want some tests that demonstrate the API is working.

  Scenario: UIWebView /dump route
    Given I am looking at the UIWebView tab
    And I can see the h1 header with css
    Then I can call /dump

  Scenario: WKWebView /dump route
    Given I am looking at the WKWebView tab
    And I can see the h1 header with css
    Then I can call /dump
