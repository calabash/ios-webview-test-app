#!/usr/bin/env bash

cd CalWebViewApp

bundle install
make app-cal

bundle exec cucumber

