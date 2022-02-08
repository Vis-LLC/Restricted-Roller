#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL

DEL out\rr-browser.js
haxe com.roller -js out\rr-browser.js -cp src -D JS_BROWSER
MOVE out\rr-browser.js out\rr-browser.tmp
TYPE Append_To_Beginning.txt > out\rr-browser.js
TYPE out\rr-browser.tmp >> out\rr-browser.js
DEL out\rr-browser.tmp
popd
