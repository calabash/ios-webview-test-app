| master  |  [license](LICENSE) |
|---------|---------------------|
|[![Build Status](https://travis-ci.org/calabash/ios-webview-test-app.svg?branch=master)](https://travis-ci.org/calabash/ios-webview-test-app)| [![License](https://img.shields.io/badge/licence-MIT-blue.svg)](http://opensource.org/licenses/MIT) |

## CalWebView App

An app with a UIWebView and a WKWebView for testing Calabash iOS and Calabash iOS Server.

### Tests

This repository contains a git submodule.  **You must clone with --recursive**.

```
$ git clone --recursive git@github.com:calabash/ios-webview-test-app.git
$ cd ios-webview-test-app/CalWebViewApp
$ bundle
$ make app-cal
$ be cucumber
```

### Console

```
$ APP=./CalWebView-cal.app be calabash-ios console
> start_test_server_in_background
```
