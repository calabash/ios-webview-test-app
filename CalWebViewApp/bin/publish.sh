#!/usr/bin/env bash

SERVER=calabash-ci.macminicolo.net

IFRAME_SOURCE="CalWebViewApp/iframe.html"
PAGE_SOURCE="CalWebViewApp/page.html"

IFRAME_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/iframe.html"
PAGE_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/page.html"

scp "${IFRAME_SOURCE}" jenkins@calabash-ci.macminicolo.net:${IFRAME_TARGET}
scp "${PAGE_SOURCE}" jenkins@calabash-ci.macminicolo.net:${PAGE_TARGET}

