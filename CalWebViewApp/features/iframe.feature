Feature: iframe API
  In order to maintain a stable WebView iframe API
  As a Calabash iOS maintainer
  I want some tests that demonstrate the API is working.

  Scenario: Query within a UIWebView iframe
    Given I am looking at the UIWebView tab
    And I can see the iframe
    Then I can query within the iframe with css for 3 "input"
    And I can query within the iframe with css for 1 "button"
    And I can query within the iframe with css for 1 "textarea"

  Scenario: Query within a WKWebView iframe
    Given I am looking at the WKWebView tab
    And I can see the iframe
    Then I can query within the iframe with css for 3 "input"
    And I can query within the iframe with css for 1 "button"
    And I can query within the iframe with css for 1 "textarea"

  Scenario: Query UIWebView iframe elements by id using css
    Given I am looking at the UIWebView tab
    And I can see the iframe
    Then I can query for "input" with id "name"
    And I can query for "input" with id "email"
    And I can query for "input" with id "password"
    And I can query for "textarea" with id "textarea"
    And I can query for "button" with id "button"

  Scenario: Query UIWebView iframe elements by id using css
    Given I am looking at the WKWebView tab
    And I can see the iframe
    Then I can query for "input" with id "name"
    And I can query for "input" with id "email"
    And I can query for "input" with id "password"
    And I can query for "textarea" with id "textarea"
    And I can query for "button" with id "button"

  Scenario: Enter text in input fields within UIWebView iframe using css
    Given I am looking at the UIWebView tab
    And I can see the iframe
    Then I can enter "calabash" in the "input" with id "name"
    And I can enter "cal@ba.sh" in the "input" with id "email"
    And I can enter "C@1AB@5H" in the "input" with id "password"

  Scenario: Enter text in input fields within WKWebView iframe using css
    Given I am looking at the WKWebView tab
    And I can see the iframe
    Then I can enter "calabash" in the "input" with id "name"
    And I can enter "cal@ba.sh" in the "input" with id "email"
    And I can enter "C@1AB@5H" in the "input" with id "password"

  Scenario: Enter text in textarea within UIWebView iframe using css
    Given I am looking at the UIWebView tab
    And I can see the iframe
    Then I can enter "Lorem Ipsum Calabus" in the "textarea" with id "textarea"

  Scenario: Enter text in textarea within WKWebView iframe using css
    Given I am looking at the WKWebView tab
    And I can see the iframe
    Then I can enter "Lorem Ipsum Calabus" in the "textarea" with id "textarea"

  Scenario: Click a button within a UIWebView iframe
    Given I am looking at the UIWebView tab
    And I can see the iframe
    When I click the "button" with id "button"
    Then I should receive confirmation that I've clicked the button

  Scenario: Click a button within a WKWebView iframe
    Given I am looking at the WKWebView tab
    And I can see the iframe
    When I click the "button" with id "button"
    Then I should receive confirmation that I've clicked the button
