Feature: CSS API
  In order to maintain a stable WebView CSS API
  As a Calabash iOS maintainer
  I want some tests that demonstrate the API is working.

  Scenario: Query UIWebView with css
    Given I am looking at the UIWebView tab
    And I can see the h1 header with css
    Then I can query for hrefs with css
    And I can query for the body with css
    When I query with css I should see at least 2 unordered lists

  Scenario: Query WKWebView with css
    Given I am looking at the WKWebView tab
    And I can see the h1 header with css
    Then I can query for hrefs with css
    Then I can query for the body with css
    When I query with css I should see at least 2 unordered lists

  Scenario: Query UIWebView for li with id using css
    Given I am looking at the UIWebView tab
    And I can see the h1 header with css
    Then I can use css to find the "watermelon" list item

  Scenario: Query WKWebView for li with id using css
    Given I am looking at the WKWebView tab
    And I can see the h1 header with css
    Then I can use css to find the "watermelon" list item

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

  @restart
  Scenario: Touch button on UIWebView with css
    Given I am looking at the UIWebView tab
    And I can see the green line with css
    When I touch the toggle-the-secret button with css
    Then I should see the secret message with css

  @restart
  Scenario: Touch button on WKWebView with css
    Given I am looking at the WKWebView tab
    And I can see the green line with css
    When I touch the toggle-the-secret button with css
    Then I should see the secret message with css
