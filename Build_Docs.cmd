#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out
haxe  -cp src -D doc-gen --macro include('com.roller') --no-output -xml doc.xml
haxelib run dox --toplevel-package com.roller -i doc.xml -o pages --title "Restricted Roller"
pushd doc-src
pdflatex rr.tex
make4ht -c htlatex.cfg rr.tex "xhtml,NoFonts,-css"
del *.aux
del *.log
del *.dvi
del *.idv
del *.lg
del *.tmp
del *.xref
del *.4ct
del *.4tc
del *.fls
del *.fdb_latexmk
move *.pdf ..\out
move *.html ..\out
move *.css ..\out
popd
popd
