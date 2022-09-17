#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL

ECHO Building Library
DEL out\rr.py
haxe --python out/rr.py out com.roller -cp src -D %* $*
MOVE out\rr.py out\rr.tmp
TYPE Append_To_Beginning.py > out\rr.py
TYPE out\rr.tmp >> out\rr.py
DEL out\rr.tmp

popd