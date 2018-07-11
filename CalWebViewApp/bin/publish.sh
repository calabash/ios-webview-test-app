#!/usr/bin/env bash

set -e

IFRAME_SOURCE="CalWebViewApp/iframe.html"
PAGE_SOURCE="CalWebViewApp/page.html"

aws s3 cp "${IFRAME_SOURCE}" \
  "s3://calabash-files/webpages-for-tests/iframe.html"

aws s3 cp "${PAGE_SOURCE}" \
  "s3://calabash-files/webpages-for-tests/page.html"
