Feature: XPATH API
  In order to maintain a stable WebView XPATH API
  As a Calabash iOS maintainer
  I want some tests that demonstrate the API is working.

  Scenario: Query UIWebView with xpath
    Given I am looking at the UIWebView tab
    And I can see the h1 header with xpath
    Then I can query for hrefs with xpath
    And I can query for the body with xpath
    When I query with xpath I should see at least 1 unordered lists

  Scenario: Query WKWebView with xpath
    Given I am looking at the WKWebView tab
    And I can see the h1 header with xpath
    Then I can query for hrefs with xpath
    And I can query for the body with xpath
    When I query with xpath I should see at least 1 unordered lists

  Scenario: Query UIWebView for li with id using xpath
    Given I am looking at the UIWebView tab
    And I can see the h1 header with xpath
    Then I can use xpath to find the "watermelon" list item

  Scenario: Query WKWebView for li with id using xpath
    Given I am looking at the WKWebView tab
    And I can see the h1 header with xpath
    Then I can use xpath to find the "watermelon" list item

  Scenario: Touch internal href on UIWebView with xpath
    Given I am looking at the UIWebView tab
    And I can see the h1 header with xpath
    When I touch the internal link with xpath
    Then a query for the FAQ with xpath should succeed

  Scenario: Touch internal href on WKWebView with xpath
    Given I am looking at the WKWebView tab
    And I can see the h1 header with xpath
    When I touch the internal link with xpath
    Then a query for the FAQ with xpath should succeed

  @restart
  Scenario: Touch button on UIWebView with xpath
    Given I am looking at the UIWebView tab
    And I can see the green line with xpath
    When I touch the toggle-the-secret button with xpath
    Then I should see the secret message using xpath

  @restart
  Scenario: Touch button on WKWebView with xpath
    Given I am looking at the WKWebView tab
    And I can see the green line with xpath
    When I touch the toggle-the-secret button with xpath
    Then I should see the secret message using xpath
