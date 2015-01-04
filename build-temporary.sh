#!/bin/bash
# Loosely based on the Linux From Scratch build process

# Setup
set -e

umask 022

export BUILD=x86_64-unknown-linux-gnu
export TARGET=x86_64-muslbasecross-linux-gnu

CC=gcc
CXX=g++
jobs=-j8

export LC_ALL=POSIX
export PATH=/tools/bin:$PATH
export SRC=$ROOT/src
export DEPS=$SRC/deps
export PATCHDIR=$SRC/patches

cd $ROOT
rm -rf tools
mkdir tools
ln -s $ROOT/tools /tools

for script in $SRC/steps/temporary/*; do
	mkdir $ROOT/work
	cd $ROOT/work
	echo Running $script
	. $script
	cd $ROOT
	rm -rf $ROOT/work
	hash -r
done

# Cleanup
rm /tools
