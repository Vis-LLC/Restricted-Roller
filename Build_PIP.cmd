#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")

CALL Env.cmd

mkdir out 2> NUL

ECHO Building Library
DEL out\rr.py
haxe --python out/rr.py out com.roller -cp src -D %* $*
MOVE out\rr.py out\rr.tmp
TYPE Append_To_Beginning.py > out\rr.py
TYPE out\rr.tmp >> out\rr.py
DEL out\rr.tmp

ECHO Building PIP Package
MKDIR out\packaging
MKDIR out\packaging\src
MKDIR out\packaging\src\rr
MKDIR out\packaging\tests
ECHO. > out\packaging\src\rr\__init__.py
COPY out\rr.py out\packaging\src\rr
COPY lgpl-3.0.txt out\packaging\LICENSE
COPY README.md out\packaging

ECHO [build-system] > out\packaging\pyproject.toml
ECHO requires = ["setuptools>=42"] >> out\packaging\pyproject.toml
ECHO build-backend = "setuptools.build_meta" >> out\packaging\pyproject.toml

ECHO [metadata] > out\packaging\setup.cfg

ECHO name = rr-visllc >> out\packaging\setup.cfg
ECHO version = %PACKAGE_VERSION% >> out\packaging\setup.cfg
ECHO author = Vis LLC >> out\packaging\setup.cfg
ECHO author_email = %PACKAGE_AUTHORS_EMAIL% >> out\packaging\setup.cfg
ECHO description = %PACKAGE_DESCRIPTION% >> out\packaging\setup.cfg
ECHO long_description = file: README.md >> out\packaging\setup.cfg
ECHO long_description_content_type = text/markdown >> out\packaging\setup.cfg
ECHO url = %PROJECT_HOME% >> out\packaging\setup.cfg
ECHO project_urls = >> out\packaging\setup.cfg
ECHO. >> out\packaging\setup.cfg
ECHO    Bug Tracker = https://github.com/Vis-LLC/Restricted-Roller/issues >> out\packaging\setup.cfg
ECHO. >> out\packaging\setup.cfg
ECHO classifiers = >> out\packaging\setup.cfg
ECHO    Programming Language :: Other >> out\packaging\setup.cfg
ECHO    License :: OSI Approved :: GNU Lesser General Public License v3 (LGPLv3) >> out\packaging\setup.cfg
ECHO    Operating System :: OS Independent >> out\packaging\setup.cfg
ECHO. >> out\packaging\setup.cfg
ECHO [options] >> out\packaging\setup.cfg
ECHO package_dir = >> out\packaging\setup.cfg
ECHO     = src >> out\packaging\setup.cfg
ECHO. >> out\packaging\setup.cfg
ECHO packages = find: >> out\packaging\setup.cfg

REM python_requires = >=3.6

ECHO [options.packages.find] >> out\packaging\setup.cfg
ECHO where = src >> out\packaging\setup.cfg

pushd out\packaging
python -m build
REM py -m twine upload --repository testpypi dist\*.*
REM py -m twine upload --repository pypi dist\*.*
CD ..
COPY packaging\dist\*.* .
REM RMDIR -r packaging
popd

popd
