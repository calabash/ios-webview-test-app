Feature: CSS API
  In order to maintain a stable WebView CSS API
  As a Calabash iOS maintainer
  I want some tests that demonstrate the API is working.

  Scenario: Touch internal href on UIWebView with css
    Given I am looking at the UIWebView tab
    And I can see the h1 header with css
    When I touch the internal link with css
    Then a query for the FAQ with css should succeed

  Scenario: Touch internal href on WKWebView with css
    Given I am looking at the WKWebView tab
    And I can see the h1 header with css
    When I touch the internal link with css
    Then a query for the FAQ with css should succeed