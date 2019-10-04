| master  |  [license](LICENSE) |
|---------|---------------------|
| [![Build Status](https://msmobilecenter.visualstudio.com/Mobile-Center/_apis/build/status/calabash.ios-webview-test-app?branchName=v-ivnosa%2Fconfigure-azdo-ci)](https://msmobilecenter.visualstudio.com/Mobile-Center/_build/latest?definitionId=3606&branchName=v-ivnosa%2Fconfigure-azdo-ci)| [![License](https://img.shields.io/badge/licence-MIT-blue.svg)](http://opensource.org/licenses/MIT) |

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
