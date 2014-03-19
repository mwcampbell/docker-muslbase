#!/bin/bash
# Loosely based on the Linux From Scratch build process

# Setup
set -e
umask 022
jobs=-j8
export LC_ALL=POSIX
export SRC=$ROOT/src
export DEPS=$SRC/deps
export PATCHDIR=$SRC/patches

for script in $SRC/steps/prerequisites/*
do
  mkdir $ROOT/work
  cd $ROOT/work
  echo Running $script
  . $script
  cd $ROOT
  rm -rf $ROOT/work
  hash -r
done
