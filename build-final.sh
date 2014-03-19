#!/bin/bash
# Loosely based on the Linux From Scratch build process

# Setup
set -e
umask 022
jobs=-j8
configure_args='--prefix= --libdir=/lib --libexecdir=/lib --bindir=/bin --sbindir=/sbin --sysconfdir=/etc --includedir=/include --localstatedir=/var --mandir=/share/man --infodir=/share/info'
export LC_ALL=POSIX
export PATH=/bin:/sbin:/tools/bin
export SRC=/src
export DEPS=$SRC/deps
export PATCHDIR=$SRC/patches

for script in $SRC/steps/final/*
do
  mkdir /work
  cd /work
  echo Running $script
  . $script
  cd /
  rm -rf /work
  hash -r
done
