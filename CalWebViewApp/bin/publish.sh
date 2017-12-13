#!/usr/bin/env bash

SERVER=calabash-ci.xyz

IFRAME_SOURCE="CalWebViewApp/iframe.html"
PAGE_SOURCE="CalWebViewApp/page.html"

IFRAME_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/iframe.html"
PAGE_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/page.html"

scp "${IFRAME_SOURCE}" jenkins@${SERVER}:${IFRAME_TARGET}
scp "${PAGE_SOURCE}" jenkins@${SERVER}:${PAGE_TARGET}
