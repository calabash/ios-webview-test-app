
@safari
Feature: Safari Web View
  To demonstrate that Calabash can interact with Safari Web Views
  As an iOS maintainer
  I want some tests that show how it is done

  Scenario: Query SafariWebView with css
    Given I am looking at the SafariWebView tab
    And I can see the h1 header with DeviceAgent
