Feature: JavaScript API
  In order to maintain a stable WebView JavaScript API
  As a Calabash iOS maintainer
  I want some tests that demonstrate the API is working.

  Scenario: Query UIWebView with javascript
    Given I am looking at the UIWebView tab
    And I can see the h1 header with javascript
    Then I can query for hrefs with javascript
    And I can query for the body with javascript
    When I query with javascript I should see 4 unordered lists

  Scenario: Query WKWebView with javascript
    Given I am looking at the WKWebView tab
    And I can see the h1 header with javascript
    Then I can query for hrefs with javascript
    And I can query for the body with javascript
    When I query with javascript I should see 4 unordered lists

  Scenario: Query UIWebView for li with id using javascript
    Given I am looking at the UIWebView tab
    And I can see the h1 header with javascript
    Then I can use javascript to find the "watermelon" list item

  Scenario: Query WKWebView for li with id using javascript
    Given I am looking at the WKWebView tab
    And I can see the h1 header with javascript
    Then I can use javascript to find the "watermelon" list item

  @restart
  Scenario: Touch button on UIWebView with javascript
    Given I am looking at the UIWebView tab
    When I touch the toggle-the-secret button with javascript
    Then I should see the secret message has been revealed using javascript

  @restart
  Scenario: Touch button on WKWebView with javascript
    Given I am looking at the WKWebView tab
    When I touch the toggle-the-secret button with javascript
    Then I should see the secret message has been revealed using javascript

  Scenario: Query UIWebView with bad javascript
    Given I am looking at the UIWebView tab
    When I query the page with bad javascript, I get back an empty array

  @wip
  Scenario: Query WKWebView with bad javascript
    Given I am looking at the WKWebView tab
    When I query the page with bad javascript, I get back a description of the error
