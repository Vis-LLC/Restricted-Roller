#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")

SET PACKAGE_NAME=com.rr
SET PACKAGE_VERSION=0.0.5
SET PACKAGE_AUTHORS=Franklin E. Powers, Jr.
SET PACKAGE_AUTHORS_EMAIL=info@vis-software.com
SET PACKAGE_OWNERS=fpowersjr
SET PROJECT_HOME=https://sourceforge.net/projects/restricted-roller/
SET PROJECT_LICENSE=LGPL-3
SET PACKAGE_ICON=
SET PACKAGE_RELEASE_NOTES=
SET PACKAGE_DESCRIPTION=Restricted Roller - Produce random results for various games/situations.
SET PACKAGE_COPYRIGHT=Copyright (C) 2020 Vis LLC
SET PACKAGE_TAGS=sudoku
SET PACKAGE_DEPENDENCIES=
SET PACKAGE_README=

popd