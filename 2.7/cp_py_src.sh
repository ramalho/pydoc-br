#!/bin/bash
PYTHON_SRC=../../cpython
cp $PYTHON_SRC/.???* . # .hgignore, .gitignore etc.
cp $PYTHON_SRC/LICENSE .
cp $PYTHON_SRC/Grammar/Grammar Grammar/
cp $PYTHON_SRC/Lib/test/exception_hierarchy.txt Lib/test/
cp $PYTHON_SRC/Parser/Python.asdl Parser/
cp -Rv $PYTHON_SRC/Doc/ Doc/