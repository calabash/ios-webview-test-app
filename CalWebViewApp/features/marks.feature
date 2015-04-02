Feature: Marked API
  In order to maintain a stable WebView marked API
  As a Calabash iOS maintainer
  I want some tests that demonstrate the API is working.

  Scenario: Queries on UIWebView with marked make partial matches on text
    Given I am looking at the UIWebView tab
    And I can see the h1 header with mark
    Then I can find the h2 header by using the mark "H2 H"
    And I can find the h2 header by using the mark "H2 He"
    And I can find the h2 header by using the mark "H2 Hea"
    And I can find the h2 header by using the mark "H2 Header!"

  Scenario: Queries on WKWebView with marked make partial matches on text
    Given I am looking at the WKWebView tab
    And I can see the h1 header with mark
    Then I can find the h2 header by using the mark "H2 H"
    And I can find the h2 header by using the mark "H2 He"
    And I can find the h2 header by using the mark "H2 Hea"
    And I can find the h2 header by using the mark "H2 Header!"

  Scenario: Touch internal href on UIWebView with mark
    Given I am looking at the UIWebView tab
    And I can see the h1 header with mark
    When I touch the internal link using the mark "Touch!"
    Then a query for the FAQ with css should succeed

  Scenario: Touch internal href on WKWebView with mark
    Given I am looking at the WKWebView tab
    And I can see the h1 header with mark
    When I touch the internal link using the mark "Touch!"
    Then a query for the FAQ with css should succeed

  @restart
  Scenario: Touch button on UIWebView with mark
    Given I am looking at the UIWebView tab
    And I find the toggle-the-secret button with mark
    When I touch the toggle-the-secret button with mark
    Then I should find the secret message with a mark

  @restart
  Scenario: Touch button on WKWebView with mark
    Given I am looking at the WKWebView tab
    And I find the toggle-the-secret button with mark
    When I touch the toggle-the-secret button with mark
    Then I should find the secret message with a mark
